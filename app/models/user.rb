class User < ActiveRecord::Base
  has_many :reviews
  has_many :queued_user_videos, -> { order 'place_in_queue' }
  # has_many :queued_videos, -> { order 'queued_user_videos.place_in_queue' }, through: :queued_user_videos, source: :video

  has_secure_password validations: false
  validates :email, presence: true, uniqueness: true
  validates_presence_of :full_name
  validates :password, presence: true, on: :create#, length: { minimum: 2 }

  # def insert_in_queue!(video, position = nil)
  #   return if queued_videos.exists? video.id

  #   count = queued_user_videos.count
  #   position = validate_position(position, count)
  #   shift_tail_back!(position) if position <= count
  #   queued_user_videos.create(video: video, place_in_queue: position)
  #   nil
  # end

  # private

  # def validate_position(position, count)
  #   if position.nil? || position > count
  #     count + 1
  #   elsif position < 1
  #     1
  #   else
  #     position
  #   end
  # end

  # def shift_tail_back!(position)
  #   tail = queued_user_videos.where("place_in_queue >= ?", position)

  #   tail.each do |queued_video|
  #     curr_place = queued_video.place_in_queue
  #     queued_video.update(place_in_queue: curr_place + 1)
  #   end
  # end
end
