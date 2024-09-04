require 'rails_helper'

RSpec.describe Schema, type: :model do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :json) }

  subject { create(:schema, name: "foo", team:, format:) }

  it { should belong_to :team }
  it { should belong_to(:service).optional }

  it { should have_many :stakeholders }
  it { should have_many :favorites }
  it { should have_many :versions }
  it { should have_many :webhooks }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).scoped_to(:service_id) }
end
