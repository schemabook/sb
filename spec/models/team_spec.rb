require 'rails_helper'

RSpec.describe Team, type: :model do
  subject { create(:team, business: create(:business)) }

  it { should have_many :users }
  it { should have_many :services }
  it { should belong_to :business }

  context "with validations" do
    it { should validate_presence_of :business_id }

    describe "uniqueness" do
      let(:name)     { "foo" }
      let(:business) { create(:business) }

      it "should prevent teams with the same name in the same business" do
        team_a = create(:team, name: name, business: business)

        expect {
          create(:team, name: team_a.name, business: business)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end

      # rubocop:disable Rails/SkipsModelValidations
      it "prevents a second team from claiming to be the administrators" do
        subject.update_column(:administrators, true)

        new_team = build(:team, business: subject.business, administrators: true)
        expect(new_team.valid?).to eq(false)
      end
      # rubocop:enable Rails/SkipsModelValidations
    end
  end

  context "callbacks" do
    context "before_save" do
      # rubocop:disable Rails/SkipsModelValidations
      it "prevents the admin team from being mutated" do
        subject.update_column(:administrators, true)

        subject.name = "foo"
        expect {
          subject.save
        }.to raise_error(StandardError, /readonly/i)
      end
      # rubocop:enable Rails/SkipsModelValidations
    end
  end

  describe "#admin?" do
    context "when the administrators attribute is true" do
      it "returns true" do
        subject.administrators = true

        expect(subject.admin?).to eq(true)
      end
    end
  end
end
