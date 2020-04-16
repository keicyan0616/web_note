# namespace :push_line do 
#   desc "push_line"
  require "date"
  
  task :push_line_message => :environment do
    aaa = "k.kawasaki(#{Date.today})"
    message = {
      type: 'text',
      text: "SmartWebNoteからLINE Botへの自動テスト送信です！(#{aaa})"
    }
    client = Line::Bot::Client.new { |config|
        config.channel_secret = "6369bc43d02546586a420d568fe55de8"
        config.channel_token = "6MEEzyQDZZfFMU/oeABzqg1OpDO29JOZc42Mm+i8G8KpzG6D+V8n+yqBzC3JIC34l8vT5+7YP88PsvdwxikPK9l6EFDclWNdsYWHlfMzIXqzYjl6KTJSKbRvdsTnV4qeOW72NC8OLe0zsynTYkwfEwdB04t89/1O/w1cDnyilFU="
    }
    response = client.push_message("U213bcd37c159e91d56615331a1446953", message)
    p response
    # redirect_to goalset_show_path
    
    # message = {
    #   type: 'text',
    #   text: '朝になりました。本日も頑張りましょう。食べた食べ物を「ひらがな」で入力すると、食品のカロリーと本日のトータルカロリーが表示されます。入力ミスの場合、「みす」と入力すると最新の入力を消去できます。カロリー計算に使ってください。'
    # }
    # client = Line::Bot::Client.new { |config|
    #   config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    #   config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    # }
    # response = client.push_message(ENV["LINE_CHANNEL_USER_ID"], message)
    # p response
  end
  
# end