class QueuedUserVideo < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :title, prefix: :video, to: :video
  delegate :category, to: :video
  delegate :name, prefix: :category, to: :category

  def rating
    review = Review.find_by user: user, video: video
    review.rating if review
  end

  def self.insert!(user, video, position = nil)
    return if self.exists?(user: user, video: video)

    queue = self.where user: user
    count = queue ? queue.size : 0
    position = validate_position(position, count)

    shift_tail_up!(position, queue) if position <= count

    self.create(user: user, video: video, place_in_queue: position)
    nil
  end

  def self.remove!(user, video)
    item = self.find_by user: user, video: video
    return unless item

    self.delete item

    queue = self.where user: user
    shift_tail_down!(item.place_in_queue, queue)

    nil
  end

  private

  def self.validate_position(position, count)
    if position.nil? || position > count
      count + 1
    elsif position < 1
      1
    else
      position
    end
  end

  def self.shift_tail_up!(position, queue)
    shift_tail! position, queue, 1
  end

  def self.shift_tail_down!(position, queue)
    shift_tail! position, queue, -1
  end

  def self.shift_tail!(position, queue, amount)
    tail = queue.where("place_in_queue >= ?", position)

    tail.each do |queued_video|
      curr_place = queued_video.place_in_queue
      queued_video.update(place_in_queue: curr_place + amount)
    end
  end
end
