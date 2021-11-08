require 'rails_helper'

RSpec.describe Service, type: :model do
  it { should belong_to :team }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).scoped_to(:team_id) }
end
