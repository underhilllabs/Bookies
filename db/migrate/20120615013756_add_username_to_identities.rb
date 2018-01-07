class AddUsernameToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :username, :string
  end
end
