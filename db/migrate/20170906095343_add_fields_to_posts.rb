class AddFieldsToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :parser_settings, :video_frame, :string
    add_column :parser_settings, :article_content, :string
    add_column :posts, :video_link, :string
    add_column :posts, :video_content, :text
  end
end
