class Adduserid < ActiveRecord::Migration
  def up
    add_column :bookmarks, :user_id, :integer, :default => 1
  end

  def down
    remove_column :bookmarks, :user_id
  end
end
