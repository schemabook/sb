require 'rails_helper'

RSpec.describe Schema, type: :model do
  it { should belong_to :team }
  it { should belong_to(:service).optional }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).scoped_to(:service_id) }
  it { should validate_presence_of :team_id }
end
