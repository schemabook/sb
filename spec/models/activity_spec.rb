require 'rails_helper'

RSpec.describe Activity, type: :model do
  let(:user) { create(:user) }

  subject { create(:activity, :with_activity_log, user: user) }

  it { should belong_to :user }
  it { should belong_to :activity_log }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :activity_log_id }
  it { should validate_presence_of :title }
  it { should validate_presence_of :detail }
end
