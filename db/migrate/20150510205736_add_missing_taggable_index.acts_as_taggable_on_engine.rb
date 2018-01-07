# This migration comes from acts_as_taggable_on_engine (originally 4)
class AddMissingTaggableIndex < ActiveRecord::Migration[5.1]
  def self.up
    add_index :taggings, [:taggable_id, :taggable_type, :context], :length => { :taggable_id => 255 }
  end

  def self.down
    remove_index :taggings, [:taggable_id, :taggable_type, :context]
  end
end
