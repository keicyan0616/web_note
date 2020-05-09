# namespace :push_line do 
#   desc "push_line"
  require "date"
  
  task :push_line_message => :environment do
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

    if @lineBotDatas != nil
      @lineBotDatas.each do |lineDatalist|
        @goalSendData = Goalset.find_by(user_id: lineDatalist.user_id)
    
        # LINE通知設定をONにしているユーザーの目標設定データが存在する場合
        if @goalSendData != nil
          message = {
            type: 'text',
            text: "### 目標設定フォローメッセージ ###

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
            config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
          }

          response = client.push_message(lineDatalist.line_uid, message)
          p response
        end
      end
    end
  end
# end