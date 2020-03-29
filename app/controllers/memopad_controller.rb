class MemopadController < ApplicationController
  
  #メモ帳表示
  def show
    @memoData = Memopad.where(user_id: current_user.id).where.not(delflag: 1).order(:orderno).order(:orderno)
    #セッションタイムアウトして、idがnullの時の処理をここに入れる
  end

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
  
  # メモ削除処理
  # debugger
  def delete
    @memoData = Memopad.where(user_id: current_user.id).where.not(delflag: 1).order(:orderno) #必ずshowメソッドと合わせること
    listCnt = 0
    @memoData.each do |memolist|
      checkFlag = params[:"del_chk#{memolist.orderno}"]
      if checkFlag == "true"
        memolist.delflag = 1
        memolist.save
        listCnt += 1
      end
    end
    if listCnt >= 1
      flash.notice = "チェック「レ」を入れたメモを削除しました。"
    end
    redirect_to memopad_show_path
  end

private
  def memopad_params
    params.require(:memopad).permit(:orderno, :title, :memo)
  end

end
