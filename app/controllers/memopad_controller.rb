class MemopadController < ApplicationController
  
  #メモ帳表示
  def show
    if user_signed_in?
      @memoData = Memopad.where(user_id: current_user.id).where.not(delflag: 1).order(:orderno).order(created_at: :desc)
    else
      #セッションタイムアウトした場合の処理(idがnullのため落ちないように)
      redirect_to new_user_session_path
    end
  end

  # メモ登録（画面表示）
  def new
    @memoData = Memopad.new
  end
  
  # メモ登録処理
  def create
    @memoData = Memopad.new(memopad_params)
    @memoData.user_id = current_user.id
    @memoData.delflag = 0
    @memoData.save
    redirect_to memopad_show_path
  end
  
  # メモ編集（画面表示）
  def edit
    @memoData = Memopad.find(params[:id])
  end
  
  # メモ編集処理
  def update
    @memoData = Memopad.find(params[:id])
    @memoData.update(memopad_params)
    @memoData.save
    redirect_to memopad_show_path
  end

  # メモ削除処理
  def delete
    @memoData = Memopad.where(user_id: current_user.id).where.not(delflag: 1).order(:orderno).order(created_at: :desc) #必ずshowメソッドと合わせること
    listCnt = 0
    @memoData.each do |memolist|
      checkFlag = params[:"del_chk#{memolist.id}"]
      if checkFlag == "true"
        memolist.delflag = 1
        memolist.save
        listCnt += 1
      end
    end
    if listCnt >= 1
      flash.notice = "チェック「レ」を入れたメモを削除しました。"
    else  
      flash.alert = "削除したいメモにチェック「レ」を入れてください。"
    end
    redirect_to memopad_show_path
  end

private
  def memopad_params
    params.require(:memopad).permit(:orderno, :title, :memo)
  end

end
