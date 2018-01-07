class FixColumnName < ActiveRecord::Migration[5.1]
  def up
    rename_column :bookmarks, :hash, :hashed_url
  end

  def down
  end
end
