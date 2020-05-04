class GoalsetController < ApplicationController
  
  # 目標設定画面
  def show
    if user_signed_in?
      @goalData = Goalset.find_by(user_id: current_user.id)
      
      if !@goalData.present?
        @goalData = Goalset.new
      end
    else
      #セッションタイムアウトした場合の処理(idがnullのため落ちないように)
      redirect_to new_user_session_path
    end
  end
  
  # マイミッション登録・編集
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
    missionData = @goalData.mission
    l_goalData = @goalData.long_goal
    m_goalData = @goalData.middle_goal
    s_goalData = @goalData.short_goal

    # ミッションを更新し、変更されていたら設定日も更新
    if params[:mission]
      @goalData.update(goalsetm_params)
      if @goalData.mission != missionData
        @goalData.mission_set_at = Time.zone.now
        @goalData.save
      end
    # 目標を更新し、変更されていたら設定日も更新
    else
      @goalData.update(goalsetg_params)
      setCnt = 0
      if @goalData.long_goal != l_goalData
        @goalData.l_goal_set_at = Time.zone.now
        setCnt += 1
      end
      if @goalData.middle_goal != m_goalData
        @goalData.m_goal_set_at = Time.zone.now
        setCnt += 1
      end
      if @goalData.short_goal != s_goalData
        @goalData.s_goal_set_at = Time.zone.now
        setCnt += 1
      end
      if setCnt >= 1
        @goalData.save
      end
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
  def goalset_params
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
