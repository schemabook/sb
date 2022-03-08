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
      let(:activity1) { create(:activity, :with_activity_log, user_id: user.id) }
      let(:activity2) { create(:activity, :with_activity_log, user_id: user.id) }

      it "returns the activities" do
        expect(described_class.for_user(user.id)).to match_array([activity1, activity2])
      end
    end

    context "without activities for users" do
      let(:user) { create(:user) }

      it "returns an empty array" do
        expect(described_class.for_user(user.id)).to match_array([])
      end
    end
  end

  describe "self.for_service" do
    context "with activities for services" do
      let(:service)   { create(:service, team: user.team, name: "foo", created_by: user.id) }
      let(:activity1) { create(:activity, :with_activity_log, user_id: user.id, resource_class: Service, resource_id: service.id) }
      let(:activity2) { create(:activity, :with_activity_log, user_id: user.id, resource_class: Service, resource_id: service.id) }

      it "returns the activities" do
        expect(described_class.for_service(service.id)).to match_array([activity1, activity2])
      end
    end

    context "without activities for services" do
      let(:service) { create(:service, team: user.team, name: "foo", created_by: user.id) }

      it "returns an empty array" do
        expect(described_class.for_service(service.id)).to match_array([])
      end
    end
  end

  describe "self.for_team" do
    context "with activities for services" do
      let!(:service)  { create(:service, team: user.team, name: "foo", created_by: user.id) }
      let(:activity1) { create(:activity, :with_activity_log, user_id: user.id, resource_class: Service, resource_id: service.id) }
      let(:activity2) { create(:activity, :with_activity_log, user_id: user.id, resource_class: Service, resource_id: service.id) }

      it "returns the activities" do
        expect(described_class.for_team(user.team)).to match_array([activity1, activity2])
      end
    end

    context "with activities for schemas" do
      let!(:schema)   { create(:schema, :with_format_and_body, team: user.team) }
      let(:activity1) { create(:activity, :with_activity_log, user_id: user.id, resource_class: Schema, resource_id: schema.id) }

      it "returns the activities" do
        expect(described_class.for_team(user.team)).to match_array([activity1])
      end
    end

    context "without activities for services" do
      let!(:service) { create(:service, team: user.team, name: "foo", created_by: user.id) }

      it "returns an empty array" do
        expect(described_class.for_team(user.team)).to match_array([])
      end
    end

    context "without activities for schemas" do
      let!(:schema) { create(:schema, :with_format_and_body, team: user.team) }

      it "returns an empty array" do
        expect(described_class.for_team(user.team)).to match_array([])
      end
    end
  end

  describe "self.for_schema" do
    context "with activities for services" do
      let(:schema)   { create(:schema, :with_format_and_body, team: user.team) }
      let(:activity) { create(:activity, :with_activity_log, user_id: user.id, resource_class: Schema, resource_id: schema.id) }

      it "returns the activities" do
        expect(described_class.for_schema(schema)).to match_array([activity])
      end
    end

    context "without activities for schema" do
      let(:schema)    { create(:schema, :with_format_and_body, team: user.team) }

      it "returns an empty array" do
        expect(described_class.for_schema(schema)).to match_array([])
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
