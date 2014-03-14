require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:video) { video = Fabricate(:video) }

    it "sets @video for authenticated users" do
      set_current_user
      get :show, id: video.id
      expect(assigns(:video)).to eq(video )
    end
  
    it "sets @reviews for authenticated users" do
      set_current_user
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end
  
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: video.id }
    end
  end

  describe "POST search" do
    it "sets results for authenticated users" do
      set_current_user
      the_matrix = Fabricate(:video, title: "The Matrix")
      post :search, search_term: "atri"
      expect(assigns(:results)).to eq([the_matrix])
    end
    
    it_behaves_like  "requires sign in" do
      let(:action) { post :search, search_term: "atri"}
    end
  end
end