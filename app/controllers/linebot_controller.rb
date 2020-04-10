class LinebotController < ApplicationController
  
  require 'line/bot'  # gem 'line-bot-api'
  require "net/http"

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


  # 能動的メッセージ送信
  def line_test
    aaa = "k.kawasaki"
    message = {
      type: 'text',
      text: "SmartWebNoteからLINE Botへのテスト送信です！(#{aaa})"
    }
    client = Line::Bot::Client.new { |config|
        config.channel_secret = "6369bc43d02546586a420d568fe55de8"
        config.channel_token = "6MEEzyQDZZfFMU/oeABzqg1OpDO29JOZc42Mm+i8G8KpzG6D+V8n+yqBzC3JIC34l8vT5+7YP88PsvdwxikPK9l6EFDclWNdsYWHlfMzIXqzYjl6KTJSKbRvdsTnV4qeOW72NC8OLe0zsynTYkwfEwdB04t89/1O/w1cDnyilFU="
    }
    response = client.push_message("U213bcd37c159e91d56615331a1446953", message)
    p response
  end
  
  #LINE連携関係
  def relation
    redirect_to 'https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=1654058944&redirect_uri=https%3A%2F%2Frocky-oasis-44209.herokuapp.com%2Frelateback&state=12345abcde&scope=openid'
    # redirect_to 'https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=1654058944&redirect_uri=https%3A%2F%2Frocky-oasis-44209.herokuapp.com&state=12345abcde&scope=openid'
  end
  
  def relateback
    flash[:success] = params[:code]
    redirect_to goalset_show_path
    # params = { title: "my task" }
    # uri = URI.parse("https://api.line.me/oauth2/v2.1/token")
    # response = Net::HTTP.post_form(uri, params)
    
    # response.code # status code
    # response.body # response body
  end

end

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