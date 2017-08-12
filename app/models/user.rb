class User < ActiveRecord::Base
  has_many :reviews
  has_many :queued_user_videos
  has_many :queued_videos, -> { order 'queued_user_videos.place_in_queue' }, through: :queued_user_videos, source: :video
  # has_many :videos, through: :queued_user_videos

  has_secure_password validations: false
  validates :email, presence: true, uniqueness: true
  validates_presence_of :full_name
  validates :password, presence: true, on: :create#, length: { minimum: 2 }
end
