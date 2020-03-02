class GoalsetController < ApplicationController
  
  # 目標設定画面
  def show
    @goalData = Goalset.find_by(user_id: current_user.id)
  end

end
