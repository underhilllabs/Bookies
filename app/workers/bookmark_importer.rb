class BookmarkWorker
  @queue = :bookmark_import_queue
  def self.perform(user_id)
  end
end
