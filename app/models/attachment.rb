class Attachment < Ckeditor::Asset
  delegate :path, :url, to: :data
  # attr_accessor :file, :assetable_id, :file_file_name
  def title
    "#{id}-image"
  end

  rails_admin do
    visible false
  end

end
