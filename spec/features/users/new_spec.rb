require 'rails_helper'

RSpec.describe "user new page" do
  describe "As a guest a user can register a new account" do
    before (:each) do
      visit new_user_path
    end

    it "has a form for name, email, password, and password confirmation" do
      fill_in :full_name, with: "Kyle schulz"
      fill_in :email, with: "kylschulz@gmail.com"
      fill_in :password, with: "password"
      fill_in :password_confirmation, with: "password"
      click_on "Submit"

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Please activate your account by visiting the confirmation email you received")
    end

    it "validates that the email is valid" do
      fill_in :full_name, with: "Kyle schulz"
      fill_in :email, with: "kylschulzgmail.com"
      fill_in :password, with: "password"
      fill_in :password_confirmation, with: "password"
      click_on "Submit"

      expect(page).to have_content("Email is invalid")
    end

    it "validates that the password is valid" do
      fill_in :full_name, with: "Kyle schulz"
      fill_in :email, with: "kylschulz@gmail.com"
      fill_in :password, with: "passwo"
      fill_in :password_confirmation, with: "password"
      click_on "Submit"

      expect(page).to have_content("Password confirmation doesn't match Password")
    end

    it "validates that the name is valid" do
      fill_in :full_name, with: ""
      fill_in :email, with: "kylschulz@gmail.com"
      fill_in :password, with: "password"
      fill_in :password_confirmation, with: "password"
      click_on "Submit"

      expect(page).to have_content("Full name can't be blank")
    end

    it "can't create account with already used email" do
      user = User.create!(full_name: 'hi', email: 'kylschulz@gmail.com', password: 'password', password_confirmation: 'password')
      fill_in :full_name, with: "kyle schulz"
      fill_in :email, with: "kylschulz@gmail.com"
      fill_in :password, with: "password"
      fill_in :password_confirmation, with: "password"
      click_on "Submit"

      expect(page).to have_content("Email has already been taken")
    end

    it 'sends confirmation email with link that needs to be clicked before a user can login' do

      expect(ActionMailer::Base.deliveries.count).to eq(0)

      fill_in :full_name, with: "kyle schulz"
      fill_in :email, with: "kylschulz@gmail.com"
      fill_in :password, with: "password"
      fill_in :password_confirmation, with: "password"
      click_on "Submit"

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      email = ActionMailer::Base.deliveries.last

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Please activate your account by visiting the confirmation email you received")

      user = User.find_by(email: 'kylschulz@gmail.com')

      visit registration_confirmation_user_url(user)

      expect(current_path).to eq(login_path)

      fill_in :email, with: 'kylschulz@gmail.com'
      fill_in :password, with: 'password'
      click_on 'Log In'

      expect(current_path).to eq(user_dashboard_index_path(user))
    end

    it 'user cant login after registering if they havent clicked the link in the email' do
      fill_in :full_name, with: "kyle schulz"
      fill_in :email, with: "kylschulz@gmail.com"
      fill_in :password, with: "password"
      fill_in :password_confirmation, with: "password"
      click_on "Submit"

      expect(current_path).to eq(login_path)

      fill_in :email, with: 'kylschulz@gmail.com'
      fill_in :password, with: 'password'
      click_on "Log In"

      expect(page).to have_content('Please activate your account by visiting the confirmation email you received')
    end
  end
end
