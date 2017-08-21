module ApplicationHelper
  def print_rating(rating)
    return "Be the first to review this video!" if rating.zero?
    "Rating: #{sprintf('%.1f', rating)}/5.0"
  end

  def options_for_video_reviews(rating = nil)
    options_for_select(5.downto(1).map { |i| [pluralize(i, "Star"), i] }, rating)
  end

  def queued?(video, user)
    QueuedUserVideo.exists? video: video, user: user
  end
end
