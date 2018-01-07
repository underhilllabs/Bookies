class RemovePasswordDigestFromUser < ActiveRecord::Migration[5.1]
  def up
    remove_column :users, :password_digest
  end

  def down
    add_column :users, :password_digest
  end
end
