class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.references :bookmark

      t.timestamps
    end
    add_index :tags, :bookmark_id
  end
end
