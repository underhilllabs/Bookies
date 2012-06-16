class UsersController < ApplicationController

  respond_to :html, :json

  #before_filter :check_authentication
  def check_authentication
    unless session[:user_id]
      session[:intended_action] = action_name
      session[:intended_controller] = controller_name
      redirect_to new_session_url
    end
  end

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @users }
    end
  end

  # GET /user/login
  def login
    respond_to do |format|
      format.html { redirect_to(users_url) }
    end    
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end


  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    
    if @user.save
      redirect_to root_url, :notice => 'Successfully signed up!'
    else
      render "new"
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:notice] = "User was successfully updated."
    end

    respond_with @user
  end



  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end    
  end

  # EDIT /users/1
  def edit
    @user = User.find(params[:id])
    if session[:user_id] == @user.id
      respond_with @user
    else 
      redirect_to root_url, :notice => "Sorry, you do not have permissions to edit that user!"
    end
  end

  def show
    @user = User.find(params[:id])
    # FIXME -- This takes a lotta time, may scrap it
    @tags = @user.tags.count(:all, :group => 'name', :order => 'count_all DESC').first(10)
    respond_to do |format|
      format.html #show.html.haml
      format.xml  { head :ok }
    end    
  end

end
