require 'rails_helper'

RSpec.describe ActivityLog, type: :model do
  let(:business) { create(:business) }

  subject { create(:activity_log, business: business) }

  it { should belong_to :business }
  it { should have_many :activities }
  it { should validate_presence_of :business_id }

  describe "for_user" do
    let!(:user)      { create(:user) }
    let!(:user2)     { create(:user, email: "foo@example.com") }
    let!(:activity)  { create(:activity, activity_log: subject, user: user) }
    let!(:activity2) { create(:activity, activity_log: subject, user: user2) }

    it "should return all activities for a given user" do
      expect(subject.for_user(user_id: user.id)).to match_array([activity])
    end
  end
end
