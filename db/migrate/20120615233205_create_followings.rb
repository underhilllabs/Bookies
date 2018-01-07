class CreateFollowings < ActiveRecord::Migration[5.1]
  def change
    create_table :followings do |t|
      t.integer :user_id
      t.integer :following_id

      t.timestamps
    end
  end
end
