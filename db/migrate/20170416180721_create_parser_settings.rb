class CreateParserSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :parser_settings do |t|
      t.string :base_url
      t.string :base_links_selector
      t.string :title_selector
      t.string :content_selector
      t.string :gallery_selector
      t.string :date_selector
      t.string :tags_selector
      t.string :category_selector
      t.belongs_to :category, index: true
      t.timestamps
    end
  end
end
