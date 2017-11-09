class Modules::Post::Video < Video

  belongs_to :assetable, polymorphic: true, inverse_of: :video

  rails_admin do
    visible false
    exclude_fields :type,
                   :created_at,
                   :updated_at,
                   :uploaded_at,
                   :file_updated_at,
                   :file_file_size,
                   :file_content_type,
                   :assetable_type,
                   :assetable_id
  end
end