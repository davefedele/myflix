require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1,queue_item2])
    end

    it_behaves_like  "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    it "redirects to the my queue page" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item that is associated with the video" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates the queue item that is associated with the signed in user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(alice)
    end

    it "video at the end of the queue" do
      alice = Fabricate(:user)
      set_current_user(alice)
      the_matrix = Fabricate(:video)
      Fabricate(:queue_item, video: the_matrix, user: alice)
      ghostbusters = Fabricate(:video)
      post :create, video_id: ghostbusters.id
      ghostbusters_queue_item = QueueItem.where(video_id: ghostbusters.id, user_id: alice.id).first
      expect(ghostbusters_queue_item.position).to eq(2)
    end

    it "does not add the video to the queue if it already exists in the queue" do
      alice = Fabricate(:user)
      set_current_user(alice)
      the_matrix = Fabricate(:video)
      Fabricate(:queue_item, video: the_matrix, user: alice)
      post :create, video_id: the_matrix.id
      expect(alice.queue_items.count).to eq(1)
    end

    it_behaves_like  "requires sign in" do
      let(:action) { post :create, video_id: 3}
    end

  end

  describe "DESTROY destroy" do
    it "should redirect to the queue page" do
      set_current_user
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue item" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item = Fabricate(:queue_item, user: alice)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end
    
    it "does not delete the queue item if the queue item is not in the current user's queue" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(alice)
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it "normalizes the remaining queue items" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
      queue_item1 = Fabricate(:queue_item, user: alice, position: 2)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 3 }
    end
  end

  describe "POST update_queue" do
    it_behaves_like "requires sign in" do
      let(:action) do
        post :update_queue, queue_items: [{id: 2, position: 3}, {id: 5, position: 2}]
      end
    end
    
    context "with valid inputs" do    
      
      let(:alice) { Fabricate(:user) }
      let(:video) { video = Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2, video: video) }

      before { set_current_user(alice) }


      it "redirect to the my queue page" do
        
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 1}]
        expect(alice.queue_items.map(&:position)).to eq([1,2])
      end
    end
    
    context "with invalid inputs" do
      let(:alice) { Fabricate(:user) }
      let(:video) { video = Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2, video: video) }

      before { set_current_user(alice) }

      it "redirect to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.4}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.4}, {id: queue_item2.id, position: 1}]
        expect(flash[:danger]).to be_present
      end
      it "does not change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1) 
      end
    end

    context "with queue items that don't belong to the current user" do
      it "doesn't change the queue items" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        set_current_user(alice)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: bob, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end

end