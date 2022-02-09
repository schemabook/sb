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

  describe "self.for_user" do
    context "with activities for users" do
      let(:activity_1) { create(:activity, :with_activity_log, user_id: user.id) }
      let(:activity_2) { create(:activity, :with_activity_log, user_id: user.id) }

      it "returns the activities" do
        expect(described_class.for_user(user.id)).to match_array([activity_1, activity_2])
      end
    end

    context "without activities for users" do
      let(:user) { create(:user) }

      it "returns an empty array" do
        expect(described_class.for_user(user.id)).to match_array([])
      end
    end
  end

  describe "#resource" do
    let!(:resource) { create(:business) }
    let!(:activity) { create(:activity, :with_activity_log, user: user, title: "foo", detail: "bar", resource_class: resource.class.to_s, resource_id: resource.id) }

    it "should return an instance of the resource" do
      expect(activity.resource).to eq(resource)
    end
  end
end
