require 'spec_helper'

describe ForgotPasswordsController do
  
  describe "POST create" do
  
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end
      
      it "shows the error message" do
        post :create, email: ''
        expect(flash[:danger]).to eq("Email cannot be blank.")
      end
    end

    context "with existing email" do
      it "redirects to the forgot password confirmation page" do
        Fabricate(:user, email: "dave@example.com")
        post :create, email: "dave@example.com"
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "send an email to the email address" do
        Fabricate(:user, email: "dave@example.com")
        post :create, email: "dave@example.com"
        expect(ActionMailer::Base.deliveries.last.to).to eq(["dave@example.com"])
      end
    end

    context "with non-existng email" do
      it "redirects to the forgot password page" do
        post :create, email: "unknown@site.com"
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error message" do
        post :create, email: "unknown@site.com"
        expect(flash[:danger]).to eq("Email address not registered.")
      end
    end
  end
end