require 'spec_helper'

describe Category do
  it { should have_many(:videos)}
  it { should validate_uniqueness_of(:name)}
  describe "#recent_videos" do
    it "returns the videos in the reverse chronological order by created_at" do
      favorites = Category.create(name: "favorites")
      the_matrix = Video.create(title: "The Matrix", description: "Sci-Fi movie", created_at: 1.day.ago, category: favorites)
      princess_bride = Video.create(title: "The Princess Bride", description: "True Love", category: favorites)
      expect(favorites.recent_videos).to eq([princess_bride,the_matrix])
    end
    it "returns all the videos if there are less than six videos" do
      favorites = Category.create(name: "favorites")
      the_matrix = Video.create(title: "The Matrix", description: "Sci-Fi movie", created_at: 1.day.ago, category: favorites)
      princess_bride = Video.create(title: "The Princess Bride", description: "True Love", category: favorites)
      expect(favorites.recent_videos.count).to eq(2)
    end
    it "returns only six videos if there are more than six videos in the category" do
      favorites = Category.create(name: "favorites")
      7.times { Video.create(title: "The Matrix", description: "Sci-Fi movie", created_at: 1.day.ago, category: favorites)}
      expect(favorites.recent_videos.count).to eq(6)
    end  
    it "returns the six most recent videos" do
      favorites = Category.create(name: "favorites")
      6.times { Video.create(title: "The Matrix", description: "Sci-Fi movie", category: favorites)}
      spy_game = Video.create(title: "Spy Game", description: "Spy Movie", created_at: 1.day.ago, category: favorites)
      expect(favorites.recent_videos).not_to include(spy_game)
    end
    it "returns an empty array if the category doesn't have any videos" do
      favorites = Category.create(name: "favorites")
      expect(favorites.recent_videos).to eq([])
    end
  end
end