class Video < ActiveRecord::Base
  belongs_to  :category

  validates_presence_of :title, :description

  before_save :generate_slug

  def generate_slug
    self.slug = self.title.gsub(' ', '-').downcase
  end

  def to_param
    self.slug
  end
end