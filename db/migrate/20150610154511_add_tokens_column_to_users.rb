class AddTokensColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :tokens, :text
  end
end
