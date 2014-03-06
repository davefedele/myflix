require 'spec_helper'

describe Video do
  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}
  it { should have_many(:reviews).order("created_at DESC")}
  
  describe "search_by_title" do
    let(:the_matrix) { the_matrix = Video.create(title: "The Matrix", description: "Sci-Fi movie") }
    let(:princess_bride) { princess_bride = Video.create(title: "The Princess Bride", description: "True Love") }

    it "returns an empty array if there are no matches" do
      expect(Video.search_by_title("Helicopter")).to eq([])
    end
    it "returns an array of one video for an exact match" do
      expect(Video.search_by_title("The Matrix")).to eq([the_matrix])
    end
    it "returns an array of one video for a partial match" do
      expect(Video.search_by_title("atrix")).to eq([the_matrix])
    end
    it "returns an array of all matches ordered by created_at" do
      the_matrix = Video.create(title: "The Matrix", description: "Sci-Fi movie", created_at: 1.day.ago)
      expect(Video.search_by_title("ri")).to eq([princess_bride,the_matrix])
    end
    it "returns an empty array when the search string is empty" do
      expect(Video.search_by_title("")).to eq([])
    end
  end
end