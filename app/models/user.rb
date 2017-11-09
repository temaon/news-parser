class User < ApplicationRecord
  # include RailsAdmin::User

  acts_as_commontator

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :posts, dependent: :destroy, source: :posts, inverse_of: :user
  accepts_nested_attributes_for :posts, allow_destroy: true

end
