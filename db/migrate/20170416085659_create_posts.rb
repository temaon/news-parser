class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug, index: true, unique: true
      t.text :short_description
      t.text :description
      t.belongs_to :category, index: true, foreign_key: true
      t.string :original_url
      t.timestamps
    end
    add_column :posts, :date, :datetime
    add_column :posts, :is_main, :boolean, default: true
    add_column :posts, :is_commentable, :boolean, default: true
    add_column :posts, :watches_count, :integer, default: 0
  end
end
