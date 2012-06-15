class AddUsernameToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :username, :string
  end
end
