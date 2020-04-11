class GoalsetController < ApplicationController
  
  # 目標設定画面
  def show
    @goalData = Goalset.find_by(user_id: current_user.id)
    
    if !@goalData.present?
      @goalData = Goalset.new
    end
    @showFlag = 1
  end
  
  def edit
    @goalData = Goalset.find_by(user_id: current_user.id)
    
    if !@goalData.present?
      @goalData = Goalset.new
    end
  end
  
  def update
    @goalData = Goalset.update(goalset_params)
    redirect_to goalset_show_path
  end
  
  def create
    
  end

private
  def goalset_params
    params.require(:goalset).permit(:mission, \
                                    :l_goal_deadline_at, :long_goal, \
                                    :m_goal_deadline_at, :middle_goal, \
                                    :s_goal_deadline_at, :short_goal)
  end

end
