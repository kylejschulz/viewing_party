class User < ApplicationRecord
  has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy, inverse_of: :followee
  has_many :followees, through: :followed_users
  has_many :parties, dependent: :destroy, inverse_of: :host
  has_many :following_users, foreign_key: :followee_id, class_name: 'Follow', dependent: :destroy, inverse_of: :followee
  has_many :followers, through: :following_users
  has_secure_password
  validates :full_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :password, presence: true
  validates :password, confirmation: { case_sensitive: true }

  before_create :confirmation_token

  def parties_im_invited_to
    parties = Invitee.where(user_id: id).pluck(:party_id)
    Party.find(parties)
  end

  def confirmation_token
    self.confirm_token = SecureRandom.urlsafe_base64.to_s if confirm_token.blank?
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end
end
