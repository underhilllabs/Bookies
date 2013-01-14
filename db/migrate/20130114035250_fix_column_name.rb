class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :bookmarks, :hash, :hashed_url
  end

  def down
  end
end
