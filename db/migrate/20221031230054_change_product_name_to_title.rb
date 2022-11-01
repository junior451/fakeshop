class ChangeProductNameToTitle < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :name, :title
  end
end
