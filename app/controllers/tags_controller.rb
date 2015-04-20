class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :archive, :delete, :search, :user, :bookmarks, :rename] 
  # caches_page :index
  respond_to :html, :json

  def index
    cutoff = 20
    # @tags = Tag.all
    # select name, count(1) from tags GROUP BY name;
    # @tags = Tag.count(:all, :group => 'name', :order => 'count_all DESC')
    # @tags = Tag.count(:all, :group => 'name', :order => 'count_all DESC').reject! {|k,v| v < cutoff }
    @tags = Tag.group("name").having("count(name) > :cutoff", :cutoff => cutoff).order("count(name) DESC").count()
    respond_with @tags
  end

  def user
    # @tags = Tag.all
    # select name, count(1) from tags GROUP BY name;
    @user = User.find(params[:id])
    @tags = Tag.where(:user_id => params[:id]).count(:all, :group => 'name', :order => 'count_all DESC')
  end


  def name
    # use pluck instead of includes
    bookmarks = Tag.where(:name => params[:name]).pluck(:bookmark_id)
    @bookmarks = Bookmark.where(:id => bookmarks).order(:updated_at).reverse_order.page(params[:page]).per_page(30)
    @name = params[:name]
    respond_with @bookmarks
  end

  def bookmarks
    # deprecated in rails 4
    # @bookmarks = Tag.find_all_by_name(tag.name).map(&:bookmark).order("updated_at DESC")
    @bookmarks = Tag.where(name: tag.name).map(&:bookmark).order("updated_at DESC")
    respond_with @bookmarks
  end

  # GET /tags/1
  # GET /tags1.xml
  def show
  end

  def rename
    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to(@tag, :notice => 'Tag was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end

  end

  # DELETE /tag/1
  # DELETE /tag/1.xml
  def delete
    @tag.destroy
    redirect_to(tags_url)
  end

  # GET /tag/1/rename/name
  def update
    if @tag.update_attributes(params[:name])
      format.html { redirect_to(@tag, :notice => 'Tag was successfully renamed.') }
    else
      format.html { render :action => "edit" }
    end
  end


  def search
  end

  private
  def set_tag
    @tag = Tag.find(params[:id])
  end
end
