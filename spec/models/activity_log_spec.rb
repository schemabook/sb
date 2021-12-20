require 'rails_helper'

RSpec.describe ActivityLog, type: :model do
  let(:business) { create(:business) }

  subject { create(:activity_log, business: business) }

  it { should belong_to :business }
  it { should validate_presence_of :business_id }
end
