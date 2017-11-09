class AddIsMainFieldToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :is_main, :boolean, default: false
    add_column :categories, :watches_count, :integer, default: 0
    add_column :categories, :template, :integer, default: 0
  end
end
