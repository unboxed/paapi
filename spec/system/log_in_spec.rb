# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Home page renders correctly" do
  let(:user) { create(:user) }

  context "when a user is not signed in" do
    before do
      visit root_path
    end

    it "redirects to login" do
      expect(page).to have_text("Email")
      expect(page).not_to have_text("This service allows ...")
    end

    it "cannot log in with invalid credentials" do
      fill_in("user[email]", with: user.email)
      fill_in("user[password]", with: "invalid_password")
      click_button("Log in")

      expect(page).to have_text("Invalid Email or password.")
      expect(page).not_to have_text("Signed in successfully.")
    end
  end

  context "when a user is signed in with valid credentials" do
    before do
      sign_in user
      visit root_path
    end

    it "will redirect to homepage" do
      expect(page).to have_text("This service allows ...")
    end
  end
end
