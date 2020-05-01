class TodolistController < ApplicationController
  
  # ToDoリスト画面
  def show
    if user_signed_in?
      @todoData = Todolist.where(user_id: current_user.id, delflag: 0).order(start_date: :asc)
      @todoFinishData = Todolist.where(user_id: current_user.id, delflag: 1).order(start_date: :asc)
    else
      #セッションタイムアウトした場合の処理(idがnullのため落ちないように)
      redirect_to new_user_session_path
    end
  end

  # ToDo登録画面
  def new
    @todoNewData = Todolist.new
  end
  
  # ToDo登録処理
  def create
    #logger.debug "#{params[:id]}#{params[:todolist][:todo]}ここを通ったよ(010)"
    # @todoData = Todolist.new(
    #     user_id: params[:id],
    #     todo: params[:todolist][:todo] #,
    #     # start_date: params[:todolist][:start_date]
    # )
    @todoData = Todolist.new(todolist_params)
    @todoData.user_id = current_user.id
    @todoData.delflag = 0
    @todoData.save
    redirect_to todolist_show_path
  end
  
  # ToDo完了処理
  def finish
    @todoData = Todolist.find(params[:id])
    @todoData.delflag = 1
    @todoData.save
    redirect_to todolist_show_path
  end
  
  # ToDo編集
  def edit
    @todoData = Todolist.find(params[:id])
  end
  
  # ToDo削除処理
  def delete
    @todoData = Todolist.find(params[:id])
    @todoData.delflag = 2
    @todoData.save
    redirect_to todolist_show_path
  end
  
private
  def todolist_params
    params.require(:todolist).permit(:todo, :start_date)
    # params.require(:todolist).permit(:id, :todo, :start_date)
  end
  
end
