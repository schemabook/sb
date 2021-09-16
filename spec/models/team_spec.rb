require 'rails_helper'

RSpec.describe Team, type: :model do
  it { should have_many :users }
  it { should belong_to :business }

  it { should validate_presence_of :business_id }
end
