class Invitee < ApplicationRecord
  belongs_to :party
  belongs_to :user

  delegate :full_name, to: :user

  def user?(user_id)
    return 'font-weight:bold' if self.user_id == user_id
    'font-weight:normal'
  end

  def self.create_multiple_invitees(friend_ids, party_id)
    return unless friend_ids != ['']

    friend_ids.each do |friend_id|
      Invitee.create!(party_id: party_id, user_id: friend_id) if friend_id != ''
    end
  end
end
