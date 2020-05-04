class LinebotController < ApplicationController
  
  require 'line/bot'  # gem 'line-bot-api'
  require "net/https"
  require 'uri'
  require 'securerandom'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  # イベント発生時
  def callback
    # Postモデルの中身をランダムで@postに格納する
    # @post=Post.offset( rand(Post.count) ).first
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
      #userId取得
      userId = event['source']['userId']
    
      # if文でresponseに送るメッセージを格納
      # event.message['text']でLINEで送られてきた文書を取得
      if event.message['text'].include?("好き")
        response = "んほぉぉぉぉぉぉ！すきすきすきすきすきすきすきすきぃぃぃぃぃ"
      elsif event.message["text"].include?("行ってきます")
        response = "どこいくの？どこいくの？どこいくの？寂しい寂しい寂しい。。。"
      elsif event.message['text'].include?("おはよう")
        response = "おはよう。なんで今まで連絡くれなかったの？"
      elsif event.message['text'].include?("みーくん")
        response = "みーくん！？" * 50
      elsif event.message['text'].include?("ユーザーID")
        response = "あなたのユーザーIDは、[" +  userId + "]です。"
      else
        # response = @post.name
        response = "else処理です"
      end

      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    }

    head :ok
  end


  # LINEメッセージ送信ボタン（能動的メッセージ送信）
  def line_test
    @goalSendData = Goalset.find_by(user_id: current_user.id)

    message = {
      type: 'text',
      text: "### 目標設定フォローメッセージ（送信テストFromローカル）###

【マイミッション】
  #{@goalSendData.mission}

【長期目標】（#{@goalSendData.l_goal_deadline_at.strftime('%Y-%m-%d')}）
  #{@goalSendData.long_goal}

【中期目標】（#{@goalSendData.m_goal_deadline_at.strftime('%Y-%m-%d')}）
  #{@goalSendData.middle_goal}

【短期目標】（#{@goalSendData.s_goal_deadline_at.strftime('%Y-%m-%d')}）
  #{@goalSendData.short_goal}
"
      # text: "SmartWebNoteからLINE Botへのテスト送信(from ローカル)です！(#{aaa})"
    }
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      # config.channel_secret = "6369bc43d02546586a420d568fe55de8"
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      # config.channel_token = "6MEEzyQDZZfFMU/oeABzqg1OpDO29JOZc42Mm+i8G8KpzG6D+V8n+yqBzC3JIC34l8vT5+7YP88PsvdwxikPK9l6EFDclWNdsYWHlfMzIXqzYjl6KTJSKbRvdsTnV4qeOW72NC8OLe0zsynTYkwfEwdB04t89/1O/w1cDnyilFU="
    }
    response = client.push_message("U213bcd37c159e91d56615331a1446953", message)
    p response
    redirect_to goalset_show_path
  end
  
  #LINE連携関係
  def relation
    $randomState = SecureRandom.hex(8)
    redirect_to 'https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=1654058944&redirect_uri=https%3A%2F%2Frocky-oasis-44209.herokuapp.com%2Frelateback&state=12345abcde&scope=profile%20openid'
    # redirect_to 'https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=1654058944&redirect_uri=https%3A%2F%2Frocky-oasis-44209.herokuapp.com&state=12345abcde&scope=openid'
  end
  
  #LINE連携（コールバック（レスポンス）処理）
  def relateback
    # 認可コード取得
    @code = params[:code]
    

    #アクセストークン取得（POSTリクエスト（https））
    uri = URI.parse("https://api.line.me/oauth2/v2.1/token")
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # req = Net::HTTP::Post.new(uri.path)
    # req["Content-Type"] = 'application/x-www-form-urlencoded'
    req = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/x-www-form-urlencoded'})

    req.set_form_data({'grant_type' => 'authorization_code', 'code' => @code, 'redirect_uri' => 'https://rocky-oasis-44209.herokuapp.com/relateback', 'client_id' => '1654058944', 'client_secret' => '15b56c13ec0fa190259ae9d22b393aae'})
    # req.set_form_data({'grant_type' => 'authorization_code', 'code' => @code, 'redirect_uri' => goalset_show_path(code: 2), 'client_id' => '1654058944', 'client_secret' => '15b56c13ec0fa190259ae9d22b393aae'})
    # req.body = {name: "web", config: {url: "hogehogehogehoge"}}.to_json

    res = http.request(req)
    
    # http.set_debug_output $stderr
    
    result = ActiveSupport::JSON.decode(res.body)
    
    @acsToken = result["access_token"]
    @expIn = result["expires_in"]
    @idToken = result["id_token"]
    @scope = result["scope"]


    #アクセストークンからプロフィール情報（UserID）を取得
    uri = URI.parse("https://api.line.me/oauth2/v2.1/verify")
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.request_uri)
    req.set_form_data({'id_token' => @idToken, 'client_id' => '1654058944'})
 
    res = http.request(req)
    result = ActiveSupport::JSON.decode(res.body)

    @userId = result["sub"]
    @displayName = result["name"]
  end

end

  # #アクセストークンからプロフィール情報（UserID）を取得
  # uri = URI.parse("https://api.line.me/v2/profile")
  # http = Net::HTTP.new(uri.host, uri.port)

  # http.use_ssl = true
  # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  # req = Net::HTTP::Get.new(uri.request_uri, initheader = {'Authorization' => "Bearer {#{@acsToken}}"})
  # res = http.request(req)

  # result = ActiveSupport::JSON.decode(res.body)

  # @userId = result["userId"]
  # @displayName = result["displayName"]
  
  
  # redirect_to goalset_show_path(code: 3)
  
  # params = { title: "my task" }
  # uri = URI.parse("https://api.line.me/oauth2/v2.1/token")
  # response = Net::HTTP.post_form(uri, params)
  
  # response.code # status code
  # response.body # response body


  # def relateback
  #   #アクセストークンからプロフィール情報（UserID）を取得
  #   uri = URI.parse("https://api.line.me/oauth2/v2.1/verify")
  #   http = Net::HTTP.new(uri.host, uri.port)

  #   http.use_ssl = true
  #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  #   req = Net::HTTP::Post.new(uri.request_uri)
  #   req.set_form_data({'id_token' => 'eyJhbGciOiJIUzI1NiJ9.BQVRHbNGvtml0k5okx2jPQTB-IdMTEkslv-nu-yX9bOWccnmOxvsM9Z44Y9CpO_AtoS9vFXQY9vYnR6kRGgh8NHXeZfMDb28Xq3OZmaMsjqLOktFsDNtB_wduyEtkqkdTQEvihZ6kvJheSXMymOcvVbNRcD2FluXxEGFoLxjoTE.XjH37sQLirpwRbfrXCNsnXMYjFlfc_EiQbfy9ZkkkIQ', 'client_id' => '1654058944'})
 
  #   res = http.request(req)
  #   result = ActiveSupport::JSON.decode(res.body)

  #   @userId = result["sub"]
  #   @displayName = result["name"]
  # end
  
  # def relateback
  #   #アクセストークンからプロフィール情報（UserID）を取得
  #   uri = URI.parse("https://api.line.me/v2/profile")
  #   http = Net::HTTP.new(uri.host, uri.port)

  #   http.use_ssl = true
  #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  #   req = Net::HTTP::Get.new(uri.request_uri, initheader = {'Authorization' => 'Bearer {eyJhbGciOiJIUzI1NiJ9.BQVRHbNGvtml0k5okx2jPQTB-IdMTEkslv-nu-yX9bOWccnmOxvsM9Z44Y9CpO_AtoS9vFXQY9vYnR6kRGgh8NHXeZfMDb28Xq3OZmaMsjqLOktFsDNtB_wduyEtkqkdTQEvihZ6kvJheSXMymOcvVbNRcD2FluXxEGFoLxjoTE.XjH37sQLirpwRbfrXCNsnXMYjFlfc_EiQbfy9ZkkkIQ}'})
  #   res = http.request(req)
  #   result = ActiveSupport::JSON.decode(res.body)

  #   @userId = result["userId"]
  #   @displayName = result["displayName"]
  # end

# class LinebotController < ApplicationController
  
#   require 'line/bot'
#   protect_from_forgery :except => [:callback]

#   def callback
#     body = request.body.read

#     signature = request.env['HTTP_X_LINE_SIGNATURE']
#     unless client.validate_signature(body, signature)
#       error 400 do 'Bad Request' end
#     end

#     events = client.parse_events_from(body)
#     events.each { |event|
#       case event
#       when Line::Bot::Event::Message
#         case event.type
#         when Line::Bot::Event::MessageType::Text
#           message = {
#             type: 'text',
#             text: event.message['text']
#           }
#           response = client.reply_message(event['replyToken'], message)
#           p response
#         end
#       end
#     }
#     head :ok
#   end

#   private
#   def client
#     @client ||= Line::Bot::Client.new { |config|
#       config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
#       config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
#     }
#   end

# end