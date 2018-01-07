class AddNicknameToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :nickname, :string
  end
end
