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
  end

  def self.remove!(user, video)
    item = self.find_by user: user, video: video
    return unless item

    self.delete item

    queue = self.where user: user
    shift_tail_down!(item.place_in_queue, queue)

    nil
  end

  def self.update_positions!(user, new_positions)
    queue = self.where user: user

    return true unless queue.count > 0
    return false unless valid_positions?(new_positions)

    cleaned_positions = validate_positions(new_positions)

    queue.each do |item|
      new_position = cleaned_positions[item.id]

      if new_position != item.place_in_queue
        item.update(place_in_queue: new_position)
      end
    end

    true
  end

  private

  def self.valid_integer?(str)
    str == str.to_i.to_s
  end

  def self.valid_positions?(new_positions)
    !new_positions.nil? &&
      new_positions.values.all? { |i| valid_integer? i } &&
      new_positions.values.size == new_positions.values.uniq.size
  end

  def self.validate_positions(new_positions)
    id_posns_arr = new_positions.sort_by { |_, new_posn| new_posn.to_i }

    new_id_posns_arr = id_posns_arr.map.with_index do |id_posn, i|
      id = id_posn.first.to_i
      new_posn = i + 1
      [id, new_posn]
    end

    new_id_posns_arr.to_h
  end

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
