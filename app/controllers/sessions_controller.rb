class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    if user 
      session[:user_id] = user.id
      session[:username] = user.username
      redirect_to root_url, notice: "Signed in!"
    else
      flash.now.alert = "Invalid email or password"
      flash[:error] = "Invalid email or password"
      render "new"
    end   
  end

  def destroy
    session[:user_id] = nil
    session[:username] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end

