require 'spec_helper'

feature "user signs in" do
  let(:alice) { alice = Fabricate(:user) }

  scenario "with valid email and password" do
    visit sign_in_path
    fill_in "Email Address", with: alice.email
    fill_in "Password", with: alice.password
    click_button "Sign in"
    page.should have_content(alice.full_name)
  end

  scenario "with invalid email" do
    visit sign_in_path
    fill_in "Email Address", with: "oops"
    fill_in "Password", with: alice.password
    click_button "Sign in"
    page.should have_content("Invalid email or password.")
  end

  scenario "with invalid password" do
    visit sign_in_path
    fill_in "Email Address", with: alice.email
    fill_in "Password", with: "oops"
    click_button "Sign in"
    page.should have_content("Invalid email or password.")
  end
end