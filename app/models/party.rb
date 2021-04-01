class Party < ApplicationRecord
  belongs_to :movie
  belongs_to :host, class_name: 'User', foreign_key: 'user_id', inverse_of: :parties
  has_many :invitees, dependent: :destroy
  has_many :users, through: :invitees

  validates :duration, presence: true
  validates :time, presence: true
  validates :date, presence: true

  def time_format
    time.strftime('%I:%M %p')
  end

  def date_format
    date.strftime("%A %B #{time.day.ordinalize}, %Y")
  end
end
