class SessionsController < ApplicationController
  def new
  end

  # セッションなのでsession_store.rbにより5分で自動ログアウト
  def create
    if params[:password] == ENV["AUTH_PASSWORD"]
      session[:authenticated] = true
      redirect_to session[:return_to] || cities_path, success: "ログインしました"
    else
      flash.now.alert = "パスワードが違います"
      render :new, status: :unprocessable_entity
    end
  end
end
