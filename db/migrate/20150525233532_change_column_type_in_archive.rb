class ChangeColumnTypeInArchive < ActiveRecord::Migration[5.1]
  def change
    rename_column :archives, :type, :filetype
  end
end
