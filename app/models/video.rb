class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queued_user_videos
  # BCF: It's not necessary to expose access to users, is it?
  # has_many :queuers, through: :queued_user_videos, source: :user

  validates_presence_of :title, :description

  def recent_reviews
    reviews.limit(8)
  end

  def average_rating
    ratings = reviews.pluck(:rating)
    count = ratings.size
    count > 0 ? ratings.inject(:+).to_f / count : 0
  end

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where('LOWER(title) LIKE ?', "%#{search_term.downcase}%").order(created_at: :desc)
  end
end
