class Video < ActiveRecord::Base
  belongs_to  :category

  validates :title, :description, :small_cover_url, :large_cover_url, presence: true

  before_save :generate_slug

  def generate_slug
    self.slug = self.title.gsub(' ', '-').downcase
  end

  def to_param
    self.slug
  end
end