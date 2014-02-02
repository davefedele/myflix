class Video < ActiveRecord::Base
  belongs_to  :category
  has_many :reviews
  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def avg_rating
    return 0 if self.reviews.empty?
    cumulative_rating = 0
    self.reviews.each do |review|
      cumulative_rating += review.rating
    end
    cumulative_rating/self.reviews.count.to_f
  end
end