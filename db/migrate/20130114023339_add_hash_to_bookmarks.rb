class AddHashToBookmarks < ActiveRecord::Migration[5.1]
  def change
    add_column :bookmarks, :hash, :string
  end
end
