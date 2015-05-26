class ChangeColumnTypeInArchive < ActiveRecord::Migration
  def change
    rename_column :archives, :type, :filetype
  end
end
