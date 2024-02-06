class Team < ApplicationRecord
  include PublicIdGenerator

  ADMIN_TEAM_NAME = "Administrators" # admin team created when business is created

  has_many :users
  has_many :services
  has_many :schemas
  belongs_to :business

  validates :name, uniqueness: {scope: :business}
  validates :administrators, uniqueness: {scope: :business}, allow_blank: true
  validates :email, length: { in: 5..64 }, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: "only valid email addresses"
  }, allow_blank: true
  validates :channel, length: { in: 2..64 }, allow_blank: true

  def name=(val)
    if !new_record? && admin?
      write_attribute(:name, ADMIN_TEAM_NAME)
    else
      write_attribute(:name, val)
    end
  end

  def admin?
    administrators?
  end
end
