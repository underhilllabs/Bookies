class AddHashToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :hash, :string
  end
end
