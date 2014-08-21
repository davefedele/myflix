require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user " do
      get :new  
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    before do
      post :create, user: Fabricate.attributes_for(:user)
    end

    context 'with valid input' do
      
      it 'creates the user' do
        expect(User.count).to eq(1)
      end
      it 'redirects to sign in page' do
        expect(response).to redirect_to sign_in_path
      end
    end
    
    context 'with invalid input' do
      
      before do
        post :create, user: {email: "dave@example.com", 
          password: "password" }
      end

      it 'does not create a user' do
      end
      it 'renders the :new template' do
        expect(response).to render_template :new
      end
      it 'sets @user' do
        get :new
        expect(assigns(:user)).to be_instance_of(User)
      end        
    end

    context 'sending emails' do

      before { ActionMailer::Base.deliveries.clear }
      
      it "sends out an email to the user with valid input" do
        post :create, user: {email: "dave@example.com", password: "password", full_name: "Dave F"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["dave@example.com"])
      end

      it "sends an email containing the users name with valid input" do
        post :create, user: {email: "dave@example.com", password: "password", full_name: "Dave F"}
        expect(ActionMailer::Base.deliveries.last.body).to include("Dave F")
      end

      it "does not send an email with invalid input" do
        post :create, user: {email: "dave@example.com"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3}
    end
    
    it "sets @user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id 
      expect(assigns(:user)).to eq(alice)     
    end


  end
end