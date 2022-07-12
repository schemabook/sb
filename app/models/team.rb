class Team < ApplicationRecord
  ADMIN_TEAM_NAME = "Administrators" # admin team created when business is created

  has_many :users
  has_many :services
  has_many :schemas
  belongs_to :business

  validates :name, uniqueness: { scope: :business }
  validates :administrators, uniqueness: { scope: :business }, allow_blank: true

  before_save do
    readonly! if !new_record? && administrators?
  end

  def admin?
    administrators?
  end
end
