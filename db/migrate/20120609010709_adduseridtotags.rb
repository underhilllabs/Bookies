class Adduseridtotags < ActiveRecord::Migration[5.1]
  def up
    add_column :tags, :user_id, :integer, :default => 1
  end

  def down
    remove_column :tags, :user_id
  end
end
