class Team < ApplicationRecord
  ADMIN_TEAM_NAME = "Administrators" # admin team created when business is created

  has_many :users
  has_many :services
  has_many :schemas
  belongs_to :business

  validates :business_id, presence: true
  validates :name, uniqueness: { scope: :business }
  validates :administrators, uniqueness: { scope: :business }, allow_blank: true

  before_save do
    self.readonly! if !self.new_record? && self.administrators?
  end

  def admin?
    self.administrators?
  end
end
