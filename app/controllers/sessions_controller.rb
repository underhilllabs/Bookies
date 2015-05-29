class SessionsController < ApplicationController
  def new
    if params[:message] == "invalid_credentials"
      flash[:error] = 'Invalid email or password'
    end
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    if user 
      session[:user_id] = user.id
      session[:username] = user.username
      flash[:notice] = "Signed in!"
      redirect_to root_url
    else
      redirect_to root_url, notice: "Invalid email or password"
    end   
  end

  def destroy
    session[:user_id] = nil
    session[:username] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end

