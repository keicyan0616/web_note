class PagesController < ApplicationController
  before_action :sign_in_required, only: [:show]
  
  def index
    if user_signed_in?
      redirect_to schdule_show_path
    else
      redirect_to new_user_session_path
    end
  end

  def show
    #flash.now[:success] = 'ログインしました。'
    # @user = User.find(params[:id])
  end
  
  def all_event_list_class
    @id = current_user.id
    #対象期間(開始日)
    if params[:start_ymd] == ""
      @start_YMD = "1000-01-01 00:00:00"
    else
      tmp_start_YMD = params[:start_ymd] + " 00:00:00 JST"
      @start_YMD = tmp_start_YMD.in_time_zone("UTC")
    end
    #対象期間(終了日)
    if params[:end_ymd] == ""
      @end_YMD = "9999-12-31 23:59:59"
    else
      tmp_end_YMD = params[:end_ymd] + " 23:59:59 JST"
      @end_YMD = tmp_end_YMD.in_time_zone("UTC")
    end

    union_sql = Event.select("id", "title", "'スケジュール' AS _category", "description", "start_date", "end_date")
                .union(
                  Todolist.select("id", "'' AS title", "'ToDo' AS _category", "todo AS description", "start_date", "'9999-12-31 23:59:59' AS end_date")
                    .where('user_id = ?', current_user.id).where('delflag = ?', 0)
                ).to_sql
                  
    # @events = Event.from("#{union_sql} events").where('"events"."start_date" >= ? and "events"."start_date" <= ?', @start_YMD, @end_YMD).order(:start_date)
    @events = Event.from("#{union_sql} events").where(start_date: @start_YMD..@end_YMD).order(:start_date)
  end
  
  #ユーザー一覧表示
  def editusers
    @users = User.paginate(page: params[:page], per_page: 5).search(params[:search]).order(id: :asc)
  end
  
  #ユーザー一覧(対象ユーザー削除)
  def destroy
    if current_user.id.to_s != params[:id]
      @user = User.find(params[:id])
      @user.destroy
      flash.notice = '削除しました。'
    else
      flash.alert = 'ユーザー一覧からは自分のアカウントを削除できません。プロフィール変更から行ってください。'
    end
    redirect_to users_show_path
  end
end
