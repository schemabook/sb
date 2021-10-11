require 'rails_helper'

RSpec.describe User, type: :model do
  it { should belong_to :business }
  it { should belong_to :team }

  it { should accept_nested_attributes_for :business }

  it { should validate_presence_of :email }
  it { should validate_presence_of :business }
  it { should validate_presence_of :team }

  describe "#admin?" do
    let(:business) { create(:business) }
    let(:team)     { create(:team, name: Team::ADMIN_TEAM_NAME, business: business) }

    subject { create(:user, team: team) }

    it "returns true if the user belongs to the administrators team" do
      expect(subject.admin?).to eq(true)
    end
  end

  describe "#display_name" do
    subject { create(:user) }

    context "when first and last name are not set" do
      it "should return email" do
        expect(subject.display_name).to eq(subject.email)
      end
    end

    context "when first name and last name are set" do
      it "should return first and last name" do
        subject.first_name = "Robert"
        subject.last_name  = "Smith"

        expect(subject.display_name).to eq("Robert Smith")
      end
    end
  end

  describe "#display_name_with_email" do
    subject { create(:user) }

    context "when first and last name are set" do
      it "should return first and last name plus email" do
        subject.first_name = "Robert"
        subject.last_name  = "Smith"

        expect(subject.display_name_with_email).to eq("Robert Smith (#{subject.email})")
      end
    end

    context "when first and last name are not set" do
      it "should return email" do
        expect(subject.display_name_with_email).to eq(subject.email)
      end
    end
  end
end
