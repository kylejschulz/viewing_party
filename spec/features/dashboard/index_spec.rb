require 'rails_helper'

RSpec.describe "User Dashboard Index" do
  before(:each) do
    @host = create(:user, password: 'password')

    @friend_1 = create(:user, password: 'password')
    @friend_2 = create(:user, password: 'password')
    @friend_3 = create(:user, password: 'password')

    @follow_1 = create(:follow, followee: @host, follower: @friend_1)
    @follow_2 = create(:follow, followee: @host, follower: @friend_2)
    @follow_3 = create(:follow, followee: @host, follower: @friend_3)

    @movie = create(:movie)

    @party = create(:party, movie: @movie, host: @host)
    @party_2 = create(:party, movie: @movie, host: @friend_1)

    @invitee_1 = create(:invitee, party: @party, user: @friend_1)
    @invitee_3 = create(:invitee, party: @party, user: @friend_3)

    @invitee_4 = create(:invitee, party: @party, user: @host)
    @invitee_5 = create(:invitee, party: @party, user: @friend_2)
    @invitee_6 = create(:invitee, party: @party, user: @friend_3)

    visit registration_confirmation_user_url(@host)
    visit registration_confirmation_user_url(@friend_1)
    visit registration_confirmation_user_url(@friend_2)
    visit registration_confirmation_user_url(@friend_3)
  end

  describe "As an authenticated user" do
    it "Displays a greeting, 'Discover Movies' link, parties section, friends section" do
      login(@host)
      within("#greeting") do
        expect(page).to have_content("Welcome #{@host.full_name}")
      end

      within(".movies") do
        expect(page).to have_link("Discover Movies")
      end

      within(".friends") do
        expect(page).to have_css("#friend-#{@friend_1.id}")
        expect(page).to have_css("#friend-#{@friend_2.id}")
        expect(page).to have_css("#friend-#{@friend_3.id}")
      end

      within("#friend-#{@friend_1.id}") do
        expect(page).to have_content(@friend_1.full_name)
      end

      within("#friend-#{@friend_2.id}") do
        expect(page).to have_content(@friend_2.full_name)
      end

      within("#friend-#{@friend_3.id}") do
        expect(page).to have_content(@friend_3.full_name)
      end
    end

    it 'doesnt display user info if the user is not logged in' do
      visit user_dashboard_index_path(@host)

      expect(current_path).to eq(login_path)
      expect(page).to have_content("You must be logged in to perform that action")
    end

    it 'cant view another users dashboard' do
      login(@host)

      visit user_dashboard_index_path(@friend_1)

      expect(current_path).to eq(user_dashboard_index_path(@host))
      expect(page).to have_content("You can only access your own dashboard")
    end

    it "Can search for and add friends" do
      friend_4 = create(:user, email: 'email@email.com', password: 'password')

      login(@host)

      visit user_dashboard_index_path(@host)

      within(".friends") do
        expect(page).to have_field(:search)
        fill_in :search, with: "email@email.com"
        expect(page).to have_button("Add Friend")
        click_on("Add Friend")
      end

      within(".friends") do
        expect(page).to have_css("#friend-#{friend_4.id}")
      end
    end

    it "can't add a friend whose email does not exist" do
      login(@host)

      visit user_dashboard_index_path(@host)

      within(".friends") do
        expect(page).to have_field(:search)
        fill_in :search, with: "email@email.com"
        expect(page).to have_button("Add Friend")
        click_on("Add Friend")
      end

      expect(page).to have_content("Check email is valid and not your own")
    end

    it "can not add self" do
      login(@host)

      visit user_dashboard_index_path(@host)

      within(".friends") do
        expect(page).to have_field(:search)
        fill_in :search, with: @host.email
        expect(page).to have_button("Add Friend")
        click_on("Add Friend")
      end

      expect(page).to have_content("Check email is valid and not your own")
    end

    it "lists the parties i'm hosting" do
      login(@host)
      visit user_dashboard_index_path(@host)

      within('.hosted-parties') do
        expect(page).to have_link(@party.movie.title)
        expect(page).to have_content(@host.full_name)
        expect(page).to have_content(@party.duration)
        expect(page).to have_content(@party.time_format)
        expect(page).to have_content(@party.date_format)
        within(".invitees") do
          expect(page).to have_content(@friend_1.full_name)
          expect(page).to have_content(@friend_3.full_name)
        end
      end
    end

    it "lists the parties i'm invited to" do
      login(@friend_1)
      visit user_dashboard_index_path(@friend_1)

      within(".invited-parties") do
        expect(page).to have_link(@party.movie.title)
        expect(page).to have_content(@party.host.full_name)
        expect(page).to have_content(@party.duration)
        expect(page).to have_content(@party.time_format)
        expect(page).to have_content(@party.date_format)
        # within("#friends-invited-#{@invitee_4.id}") do
        #   expect(page).to have_css("bold", text: "#{@invitee_4.full_name}")
        # end
        within("#friends-invited-#{@invitee_5.id}") do
          expect(page).to have_content("#{@friend_2.full_name}")
        end
        within("#friends-invited-#{@invitee_6.id}") do
          expect(page).to have_content(@friend_3.full_name)
        end
      end
    end

    it "has a link to 'discover movies'" do
      login(@host)
      visit user_dashboard_index_path(@host)

      expect(page).to have_link('Discover Movies')
      click_on('Discover Movies')
      expect(current_path).to eq(discover_index_path)
    end
  end

  def login(user)
    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: 'password'
    click_button 'Log In'
  end
end
