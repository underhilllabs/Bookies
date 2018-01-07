class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :fullname
      t.string :website
      t.text :desc
      t.string :website2
      t.string :website3
      t.string :pic_url

      t.timestamps
    end
  end
end
