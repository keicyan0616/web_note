class GoalsetController < ApplicationController
  
  # 目標設定画面
  def show
    @goalData = Goalset.find_by(user_id: current_user.id)
    
    if !@goalData.present?
      @goalData = Goalset.new
    end
  end
  
  # ミッション登録・編集
  def editm
    @goalData = Goalset.find_by(user_id: current_user.id)
    
    if !@goalData.present?
      @goalData = Goalset.new
    end
  end

  # 目標設定・編集
  def editg
    @goalData = Goalset.find_by(user_id: current_user.id)
    
    if !@goalData.present?
      @goalData = Goalset.new
    end
  end

  def update
    @goalData = Goalset.find_by(user_id: current_user.id)
    if params[:mission]
      @goalData.update(goalsetm_params)
    else
      @goalData.update(goalsetg_params)
    end
    redirect_to goalset_show_path
  end
  
  def create
    @goalData = Goalset.new(goalset_params)
    @goalData.user_id = current_user.id
    @goalData.save
    redirect_to goalset_show_path
  end

private
  def goalsetm_params
    params.require(:goalset).permit(:mission, \
                                    :l_goal_deadline_at, :long_goal, \
                                    :m_goal_deadline_at, :middle_goal, \
                                    :s_goal_deadline_at, :short_goal)
  end

  def goalsetm_params
    params.require(:goalset).permit(:mission)
  end
  
  def goalsetg_params
    params.require(:goalset).permit(:l_goal_deadline_at, :long_goal, \
                                    :m_goal_deadline_at, :middle_goal, \
                                    :s_goal_deadline_at, :short_goal)
  end
end
