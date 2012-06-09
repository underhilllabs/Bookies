class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.string :url
      t.string :title
      t.text :desc
      t.datetime :created
      t.datetime :modified
      t.boolean :private

      t.timestamps
    end
  end
end
