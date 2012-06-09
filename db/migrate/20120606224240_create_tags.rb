class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.references :bookmark

      t.timestamps
    end
    add_index :tags, :bookmark_id
  end
end
