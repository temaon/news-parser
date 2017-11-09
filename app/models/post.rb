class Post < ApplicationRecord
  extend FriendlyId

  before_save :check_video_link

  is_impressionable counter_cache: true, column_name: :watches_count, unique: :request_hash

  friendly_id :slug_candidates, use: [:slugged, :finders]

  acts_as_taggable

  acts_as_taggable_on :tags

  # acts_as_votable
  acts_as_commontable

  paginates_per 30

  belongs_to :category, inverse_of: :posts, class_name: 'Category', foreign_key: :category_id

  has_many :images, as: :assetable, class_name: 'Modules::Post::Image', dependent: :destroy, inverse_of: :assetable
  accepts_nested_attributes_for :images, allow_destroy: true

  has_one :video, as: :assetable, class_name: 'Modules::Post::Video', dependent: :destroy, inverse_of: :assetable
  accepts_nested_attributes_for :video, allow_destroy: true

  belongs_to :user, inverse_of: :posts

  validates :title, presence: true

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
        [:title, [category: :title]],
        [:title, [category: :title], [parent: :title]]
    ]
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :russian).to_s
  end

  scope :latest, -> {order('date DESC')}

  scope :top_ten, -> {where('date > ?', Date.today - 2 ).order('watches_count DESC').order('date DESC').limit(10)}

  def next
    Post.joins(:category).where('posts.id > ? AND categories.id = ?', id, category.id).order('posts.id ASC')  # this is the default ordering for AR
  end

  def prev
    Post.joins(:category).where('posts.id < ? AND categories.id = ?', id, category.id).order('posts.id DESC')
  end

  def related_posts
    Post.includes(:tags, :images, :category).tagged_with(tag_list, :any => true).where('posts.id <> ?', id).latest
  end

  def check_video_link
    if self.video_link.present?
      video = VideoInfo.new(self.video_link)
      video.video_id if video.available?
    end rescue self.video_link
  end

end
