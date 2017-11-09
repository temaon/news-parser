class Category < ApplicationRecord
  extend FriendlyId

  is_impressionable counter_cache: true, column_name: :watches_count, unique: :request_hash

  friendly_id :title, use: [:slugged, :finders]

  enum template: {single: 0, half: 1}

  has_many :posts, dependent: :destroy, inverse_of: :category, foreign_key: :category_id, source: :posts, class_name: 'Post'
  accepts_nested_attributes_for :posts, allow_destroy: true

  has_many :parser_settings, inverse_of: :category, foreign_key: :category_id, dependent: :destroy
  accepts_nested_attributes_for :posts, allow_destroy: true

  acts_as_nested_set

  rails_admin do
    include_fields(
        :title, :is_main, :template
    )
    nested_set({
                   max_depth: 2,
                   toggle_fields: [:enabled],
                   thumbnail_fields: [:image, :cover],
                   thumbnail_size: :thumb,
                   thumbnail_gem: :paperclip,
               })
  end

  def slug_candidates
    [
        [:title, [parent: :title]]
    ]
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :russian).to_s
  end

  def template_enum
    %w(single half)
  end

end
