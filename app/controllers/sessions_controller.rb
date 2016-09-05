class SessionsController < ApplicationController
  def new
    if params[:message] == "invalid_credentials"
      flash[:error] = 'Invalid email or password'
    end
    if params[:bookmarklet] == true
      redirect_to new_bookmark_url(url: params[:url])
    end
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    if user 
      session[:user_id] = user.id
      session[:username] = user.username
      flash[:notice] = "Signed in!"
      #flash[:notice] = " with Bookmarklet #{params[:bookmarklet]}" if params[:bookmarklet]
      if params[:bookmarklet]
        redirect_to new_bookmark_url(url: params[:url])
      end
      if session[:return_to]
        redirect_to session[:return_to] 
      else 
        redirect_to :back
      end
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

