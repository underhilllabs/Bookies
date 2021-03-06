class TagsController < ApplicationController
  #before_action :set_tag, only: [:show, :edit, :update, :archive, :delete, :search, :user, :bookmarks, :rename] 
  # caches_page :index
  respond_to :html, :json

  def index
    @tags = Bookmark.tag_counts_on(:tags).order("taggings_count DESC").limit(60)
  end

  def user
    @user = User.find(params[:id])
    @tags = Bookmark.where(:user_id => params[:id]).tag_counts_on(:tags).order("taggings_count DESC").limit(60)
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
end
