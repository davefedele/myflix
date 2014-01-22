require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video )
    end
    it "redirects to the sign in page for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end
  describe "POST search" do
    it "sets results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      the_matrix = Fabricate(:video, title: "The Matrix")
      post :search, search_term: "atri"
      expect(assigns(:results)).to eq([the_matrix])
    end
    it "redirects to sign in pages for unauthenticated users" do
      the_matrix = Fabricate(:video, title: "The Matrix")
      post :search, search_term: "atri"
      expect(response).to redirect_to sign_in_path
    end
  end
end