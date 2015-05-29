class BookmarkArchive
  def initialize(bookmark)
    @bookmark = bookmark
  end

  def create
    create_bookmark_archive!
  end
 
  def destroy
    destroy_bookmark_archive!
  end

  private
    def create_bookmark_archive!
      logger.info "Queued the archiving of the url"
      Resque.enqueue(BookmarkArchive, id)
    end

    def destroy_bookmark_archive!
      logger.info "Queued the deleting of the archive"
    end
end
