class PagesController < ApplicationController
  before_action :sign_in_required, only: [:show]
  
  def index
  end

  def show
    #flash.now[:success] = 'ログインしました。'
    # @user = User.find(params[:id])
  end
end
