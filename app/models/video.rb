class Video < ActiveRecord::Base
  belongs_to :category

  # validates :title, presence: true
  # validates :description, presence: true
  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where('LOWER(title) LIKE ?', "%#{search_term.downcase}%").order(created_at: :desc)
  end
end
