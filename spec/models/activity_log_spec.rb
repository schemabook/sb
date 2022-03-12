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

  describe "for_service" do
    let!(:user)      { create(:user) }
    let!(:user2)     { create(:user, email: "foo@example.com") }
    let!(:service)   { create(:service, team: user.team, name: "foo", created_by: user.id) }
    let!(:activity)  { create(:activity, activity_log: subject, user: user, resource_class: 'Service', resource_id: service.id) }
    let!(:activity2) { create(:activity, activity_log: subject, user: user2) }

    it "should return all activities for a given service" do
      expect(subject.for_service(service_id: service.id)).to match_array([activity])
    end
  end

  describe "for_team" do
    let!(:user)      { create(:user) }
    let!(:service)   { create(:service, team: user.team, name: "foo", created_by: user.id) }
    let!(:service2)  { create(:service, team: user.team, name: "bar", created_by: user.id) }
    let!(:schema)    { create(:schema, :with_format_and_body, team: user.team) }
    let!(:activity)  { create(:activity, activity_log: subject, user: user, resource_class: 'Service', resource_id: service.id) }
    let!(:activity2) { create(:activity, activity_log: subject, user: user, resource_class: 'Service', resource_id: service2.id) }
    let!(:activity3) { create(:activity, activity_log: subject, user: user, resource_class: 'Schema', resource_id: schema.id) }

    it "should return all activities for a given team" do
      expect(subject.for_team(team: user.team)).to match_array([activity, activity2, activity3])
    end
  end

  describe "for_schema" do
    let!(:user)      { create(:user) }
    let!(:service)   { create(:service, team: user.team, name: "foo", created_by: user.id) }
    let!(:schema)    { create(:schema, :with_format_and_body, team: user.team) }
    let!(:activity)  { create(:activity, activity_log: subject, user: user, resource_class: 'Service', resource_id: service.id) }
    let!(:activity2) { create(:activity, activity_log: subject, user: user, resource_class: 'Schema', resource_id: schema.id) }

    it "should return all activities for a given schema" do
      expect(subject.for_schema(schema: schema)).to match_array([activity2])
    end
  end

  describe "for_business" do
    let!(:user)     { create(:user) }
    let!(:activity) { create(:activity, activity_log: subject, user: user, resource_class: 'Business', resource_id: user.business.id) }

    it "should return all activities for a given business" do
      expect(subject.for_business(business: user.business)).to match_array([activity])
    end
  end
end
