class Modules::Post::Image < Attachment
  has_attached_file :data, styles: {small: '25x20#', thumb: '116x116', thumb_small: '90x70#', fancy: '230x390#', medium: '425x280#', gallery: '710x450#'}, default_url: 'default/:style/default.jpg'
  validates_attachment_content_type :data, content_type: /\Aimage/
  belongs_to :assetable, polymorphic: true, inverse_of: :images

  rails_admin do
    visible false
    exclude_fields :type
  end

  scope :latest, -> {order('ckeditor_assets.created_at DESC')}
end