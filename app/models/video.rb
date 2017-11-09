class Video < Attachment
  VIDEO_CONTENT_TYPE = 'youtube_video'
  LATEST_VIDEOS_LIMIT = 5
  self.table_name = :attachments



  belongs_to :assetable, polymorphic: true, inverse_of: :video

  validates_presence_of :data_file_name

  after_initialize do
    if self.new_record?
      self.data_content_type = VIDEO_CONTENT_TYPE
      self.data_file_size = 0
      self.updated_at = Time.now
      self.type = @type || self.class.to_s
    end
  end

  def url_thumb
    "http://img.youtube.com/vi/#{file_file_name}/hqdefault.jpg"
  end

  def video_player
    "https://www.youtube.com/embed/#{file_file_name}?autoplay=0"
  end

  rails_admin do
    visible false
  end

  default_scope {where(data_content_type: VIDEO_CONTENT_TYPE)}

  scope :latest, -> (limit = LATEST_VIDEOS_LIMIT){order(created_at: :desc).limit(limit)}

end
