class CreateArchives < ActiveRecord::Migration
  def change
    create_table :archives do |t|
      t.string :url
      t.references :bookmark, index: true, foreign_key: true
      t.string :type
      t.string :location
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
