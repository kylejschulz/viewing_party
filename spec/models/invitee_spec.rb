require 'rails_helper'

RSpec.describe Invitee, type: :model do
  describe 'relationships' do
    it { should belong_to(:party) }
    it { should belong_to(:user) }
  end

  before :each do
    @movie = create(:movie)
    @host = create(:user, password: 'password')
    @friend_1 = create(:user, password: 'password2')
    @friend_2 = create(:user, password: 'password3')
    @friend_3 = create(:user, password: 'password3')
    @party = create(:party, user_id: @host.id, movie_id: @movie.id)

    Invitee.create_multiple_invitees([@friend_1.id, @friend_2.id], @party.id)

    @invitee_1 = Invitee.where(user_id: @friend_1.id, party_id: @party.id).first
    @invitee_2 = Invitee.where(user_id: @friend_2.id, party_id: @party.id).first
  end

  describe 'class methods' do
    it '#create_multiple_invitees' do
      expect(@party.invitees).to eq([@invitee_1, @invitee_2])
      expect(@invitee_1.party).to eq(@party)
      expect(Invitee.where(user_id: @friend_3.id, party_id: @party.id).first).to eq(nil)
    end
  end

  describe 'instance_methods' do
    it '#full_name' do
      expect(@invitee_1.full_name).to eq(@friend_1.full_name)
      expect(@invitee_2.full_name).to eq(@friend_2.full_name)
    end

    it '#user?' do
      expect(@invitee_1.user?(@host.id)).to eq("font-weight:normal")
      expect(@invitee_2.user?(@host.id)).to eq("font-weight:normal")
    end
  end
end
