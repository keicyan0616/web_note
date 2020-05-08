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
    # メッセージ送信対象情報の取得
    weekDay = Time.zone.now.wday
    if weekDay == 1
      @lineBotDatas = Linebot.where(valid_flag: 1, week1_flag: 1)
    elsif weekDay == 2
      @lineBotDatas = Linebot.where(valid_flag: 1, week2_flag: 1)
    elsif weekDay == 3
      @lineBotDatas = Linebot.where(valid_flag: 1, week3_flag: 1)
    elsif weekDay == 4
      @lineBotDatas = Linebot.where(valid_flag: 1, week4_flag: 1)
    elsif weekDay == 5
      @lineBotDatas = Linebot.where(valid_flag: 1, week5_flag: 1)
    elsif weekDay == 6
      @lineBotDatas = Linebot.where(valid_flag: 1, week6_flag: 1)
    elsif weekDay == 0
      @lineBotDatas = Linebot.where(valid_flag: 1, week7_flag: 1)      
    end  
    # @lineBotDatas = Linebot.where(valid_flag: 1)
    
    if @lineBotDatas != nil
      @lineBotDatas.each do |lineDatalist|
        # @goalSendData = Goalset.find_by(user_id: current_user.id)
        @goalSendData = Goalset.find_by(user_id: lineDatalist.user_id)
    
        # LINE通知設定をONにしているユーザーの目標設定データが存在する場合
        if @goalSendData != nil
          message = {
            type: 'text',
            text: "### 目標設定フォローメッセージ（送信テストat手動）###

【マイミッション】
  #{@goalSendData.mission}

【長期目標】（#{@goalSendData.l_goal_deadline_at.strftime('%Y-%m-%d')}）
  #{@goalSendData.long_goal}

【中期目標】（#{@goalSendData.m_goal_deadline_at.strftime('%Y-%m-%d')}）
  #{@goalSendData.middle_goal}

【短期目標】（#{@goalSendData.s_goal_deadline_at.strftime('%Y-%m-%d')}）
  #{@goalSendData.short_goal}
"
          }
      
          client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
            # config.channel_secret = "6369bc43d02546586a420d568fe55de8"
            config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
            # config.channel_token = "6MEEzyQDZZfFMU/oeABzqg1OpDO29JOZc42Mm+i8G8KpzG6D+V8n+yqBzC3JIC34l8vT5+7YP88PsvdwxikPK9l6EFDclWNdsYWHlfMzIXqzYjl6KTJSKbRvdsTnV4qeOW72NC8OLe0zsynTYkwfEwdB04t89/1O/w1cDnyilFU="
          }
      
          # @lineBotData = Linebot.find_by(user_id: current_user.id)
          # response = client.push_message(@lineBotData.line_uid, message)
          response = client.push_message(lineDatalist.line_uid, message)
          p response
        end
      end
    end

    redirect_to goalset_show_path
  end
  
  #LINE連携関係
  def relation
    $randomState = SecureRandom.hex(8)
    clientId = ENV["LINE_CLIENT_ID"]
    redirect_to "https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=#{clientId}&redirect_uri=https%3A%2F%2Fsmart-web-notebook.herokuapp.com%2Frelateback&state=#{$randomState}&scope=profile%20openid"
    # redirect_to 'https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=1654058944&redirect_uri=https%3A%2F%2Fsmart-web-notebook.herokuapp.com%2Frelateback&state=12345abcde&scope=profile%20openid'
    # redirect_to 'https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=1654058944&redirect_uri=https%3A%2F%2Fsmart-web-notebook.herokuapp.com&state=12345abcde&scope=openid'
  end
  
  #LINE連携（コールバック（レスポンス）処理）
  def relateback
    # 認可コード取得
    @code = params[:code]
    @cbState = params[:state]
    
    if @code != "" && @cbState == $randomState
      #アクセストークン取得（POSTリクエスト（https））
      uri = URI.parse("https://api.line.me/oauth2/v2.1/token")
      http = Net::HTTP.new(uri.host, uri.port)
  
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
      # req = Net::HTTP::Post.new(uri.path)
      # req["Content-Type"] = 'application/x-www-form-urlencoded'
      req = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/x-www-form-urlencoded'})
  
      @clientId = ENV["LINE_CLIENT_ID"]
      @clientSecret = ENV["LINE_CLIENT_SECRET"]
      req.set_form_data({'grant_type' => 'authorization_code', 'code' => @code, 'redirect_uri' => 'https://smart-web-notebook.herokuapp.com/relateback', 'client_id' => @clientId, 'client_secret' => @clientSecret})
      # req.set_form_data({'grant_type' => 'authorization_code', 'code' => @code, 'redirect_uri' => 'https://smart-web-notebook.herokuapp.com/relateback', 'client_id' => @clientId, 'client_secret' => '15b56c13ec0fa190259ae9d22b393aae'})
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
      req.set_form_data({'id_token' => @idToken, 'client_id' => @clientId})
   
      res = http.request(req)
      result = ActiveSupport::JSON.decode(res.body)
  
      @userId = result["sub"]
      @displayName = result["name"]
      
      # LinebotテーブルにUIDを書き込み
      @lineLoginUser = Linebot.find_by(user_id: current_user.id)
      if @lineLoginUser 
        @lineLoginUser.line_uid = @userId
        @lineLoginUser.save
      else
        @lineLoginUser = Linebot.new(user_id: current_user.id, line_uid: @userId, \
          valid_flag: 1, week1_flag: 0, week2_flag: 0, week3_flag: 0, week4_flag: 0, week5_flag: 0, week6_flag: 0, week7_flag: 0, \
          dotime_at: "2020-05-01 12:00:00")
        @lineLoginUser.save
      end
      
      flash.notice = "LINE連携が成功しました。"
    else
      flash.alert = "LINE連携の処理が失敗しました。"
    end
    redirect_to line_setnotice_path
  end
  
  def setnotice
    if user_signed_in?
      # LINE連携済みフラグ
      @relateFlag = 0
      # LINE通知設定フラグ
      @noticeFlag = 0
      @noticeSetFlag = true
      # 送信タイミング設定フラグ
      @timingFlag = 0
      @timingSetFlag = true
  
      @lineLoginUser = Linebot.find_by(user_id: current_user.id)
      if @lineLoginUser
        if @lineLoginUser.line_uid != nil
          @relateFlag = 1
        end
        # LINE通知設定の状態表示フラグ設定・ボタン有効化
        if @lineLoginUser.valid_flag != nil
          @noticeFlag = @lineLoginUser.valid_flag
          @noticeSetFlag = false
        end
        # 送信タイミング設定の状態表示フラグ設定・ボタン有効化
        if @lineLoginUser.valid_flag != nil
          if @lineLoginUser.week1_flag == 1 || @lineLoginUser.week2_flag == 1 || @lineLoginUser.week3_flag == 1 || \
             @lineLoginUser.week4_flag == 1 || @lineLoginUser.week5_flag == 1 || @lineLoginUser.week6_flag == 1 || \
             @lineLoginUser.week7_flag == 1
  
            @timingFlag = 1
          end
          @timingSetFlag = false
        end
      end
    else
      #セッションタイムアウトした場合の処理(idがnullのため落ちないように)
      redirect_to new_user_session_path
    end
  end
  
  # 通知「ON/OFF」の更新
  def noticeupdate
    validValue = params[:linebot][:valid_flag]
    @lineLoginUser = Linebot.find_by(user_id: current_user.id)
    if @lineLoginUser
      @lineLoginUser.valid_flag = validValue
      @lineLoginUser.save
      flash.notice = "通知設定を変更しました。"
    else
      flash.alert = "通知設定を変更できませんでした。LINEアカウントとの連携が完了しているか確認してください。"
    end
    redirect_to line_setnotice_path
  end
  
  # 送信タイミング更新
  def timingupdate
    week1Value = params[:linebot][:week1_flag]
    week2Value = params[:linebot][:week2_flag]
    week3Value = params[:linebot][:week3_flag]
    week4Value = params[:linebot][:week4_flag]
    week5Value = params[:linebot][:week5_flag]
    week6Value = params[:linebot][:week6_flag]
    week7Value = params[:linebot][:week7_flag]
    @lineLoginUser = Linebot.find_by(user_id: current_user.id)
    if @lineLoginUser
      @lineLoginUser.week1_flag = week1Value
      @lineLoginUser.week2_flag = week2Value
      @lineLoginUser.week3_flag = week3Value
      @lineLoginUser.week4_flag = week4Value
      @lineLoginUser.week5_flag = week5Value
      @lineLoginUser.week6_flag = week6Value
      @lineLoginUser.week7_flag = week7Value
      @lineLoginUser.save
      flash.notice = "送信タイミングの設定を変更しました。"
    else
      flash.alert = "送信タイミングの設定を変更できませんでした。LINEアカウントとの連携が完了しているか確認してください。"
    end
    redirect_to line_setnotice_path
  end
end