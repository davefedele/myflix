class Category < ActiveRecord::Base
  has_many  :videos

  validates :name, presence: true

  before_save :generate_slug

  def generate_slug
    self.slug = self.name.gsub(' ', '-').downcase
  end

  def to_param
    self.slug
  end
end