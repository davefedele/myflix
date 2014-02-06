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
  end
end