require 'rails_helper'

RSpec.describe ActivityLog, type: :model do
  let(:business) { create(:business) }

  subject { create(:activity_log, business:) }

  it { should belong_to :business }
  it { should have_many :activities }

  describe "for_user" do
    let!(:user)      { create(:user) }
    let!(:user2)     { create(:user, email: "foo@example.com") }
    let!(:activity)  { create(:activity, activity_log: subject, user:) }
    let!(:activity2) { create(:activity, activity_log: subject, user: user2) }

    it "should return all activities for a given user" do
      expect(subject.for_user(user_id: user.id)).to match_array([activity])
    end
  end

  describe "for_service" do
    let!(:user)      { create(:user) }
    let!(:user2)     { create(:user, email: "foo@example.com") }
    let!(:service)   { create(:service, team: user.team, name: "foo", created_by: user.id) }
    let!(:activity)  { create(:activity, activity_log: subject, user:, resource_class: 'Service', resource_id: service.id) }
    let!(:activity2) { create(:activity, activity_log: subject, user: user2) }

    it "should return all activities for a given service" do
      expect(subject.for_service(service_id: service.id)).to match_array([activity])
    end
  end

  describe "for_team" do
    let!(:user)      { create(:user) }
    let!(:service)   { create(:service, team: user.team, name: "foo", created_by: user.id) }
    let!(:service2)  { create(:service, team: user.team, name: "bar", created_by: user.id) }
    let!(:schema)    { create(:schema, :with_format, team: user.team) }
    let!(:activity)  { create(:activity, activity_log: subject, user:, resource_class: 'Service', resource_id: service.id) }
    let!(:activity2) { create(:activity, activity_log: subject, user:, resource_class: 'Service', resource_id: service2.id) }
    let!(:activity3) { create(:activity, activity_log: subject, user:, resource_class: 'Schema', resource_id: schema.id) }

    it "should return all activities for a given team" do
      expect(subject.for_team(team: user.team)).to match_array([activity, activity2, activity3])
    end
  end

  describe "for_teams" do
    let!(:user1)     { create(:user, email: 'one@example.com') }
    let!(:user2)     { create(:user, email: 'two@example.com') }
    let!(:service)   { create(:service, team: user1.team, name: "foo", created_by: user1.id) }
    let!(:service2)  { create(:service, team: user2.team, name: "bar", created_by: user2.id) }
    let!(:activity1) { create(:activity, activity_log: subject, user: user1, resource_class: 'Team', resource_id: user1.team.id) }
    let!(:activity2) { create(:activity, activity_log: subject, user: user2, resource_class: 'Team', resource_id: user2.team.id) }

    it "should return all activities for all teams" do
      expect(subject.for_teams).to match_array([activity1, activity2])
    end
  end

  describe "for_schema" do
    let!(:user)      { create(:user) }
    let!(:service)   { create(:service, team: user.team, name: "foo", created_by: user.id) }
    let!(:schema)    { create(:schema, :with_format, team: user.team) }
    let!(:activity)  { create(:activity, activity_log: subject, user:, resource_class: 'Service', resource_id: service.id) }
    let!(:activity2) { create(:activity, activity_log: subject, user:, resource_class: 'Schema', resource_id: schema.id) }

    it "should return all activities for a given schema" do
      expect(subject.for_schema(schema:)).to match_array([activity2])
    end
  end

  describe "for_schema_new" do
    let!(:user)      { create(:user) }
    let!(:schema)    { create(:schema, :with_format, team: user.team) }
    let!(:activity)  { create(:activity, activity_log: subject, user:, resource_class: 'Schema', resource_id: schema.id) }

    it "should return all schema activities" do
      expect(subject.for_schema_new).to match_array([activity])
    end
  end

  describe "for_business" do
    let!(:user)     { create(:user) }
    let!(:activity) { create(:activity, activity_log: subject, user:, resource_class: 'Business', resource_id: user.business.id) }

    it "should return all activities for a given business" do
      expect(subject.for_business(business: user.business)).to match_array([activity])
    end
  end

  describe "for_invitations" do
    let!(:user)     { create(:user) }
    let!(:teammate) { create(:user, email: "teammate@example.com") }
    let!(:activity) { create(:activity, activity_log: subject, title: "Invited Teammate", user:, resource_class: 'User', resource_id: teammate.id) }

    it "should return all activities for invitations" do
      expect(subject.for_invitations).to match_array([activity])
    end
  end

  describe "for_service_team" do
    let!(:user)     { create(:user) }
    let!(:service)  { create(:service, team: user.team, created_by: user.id) }
    let!(:activity) { create(:activity, activity_log: subject, user_id: user.id, title: "Service Created", resource_class: Service, resource_id: service.id) }

    it "should return all activities for services related to the team" do
      expect(subject.for_service_team(team: user.team)).to match_array([activity])
    end
  end
end
