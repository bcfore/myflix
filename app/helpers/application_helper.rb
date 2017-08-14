module ApplicationHelper
  def print_rating(rating)
    return "Be the first to review this video!" if rating.zero?
    "Rating: #{sprintf('%.1f', rating)}/5.0"
  end
end
