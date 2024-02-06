require 'rails_helper'

RSpec.describe Team, type: :model do
  subject { create(:team, business: create(:business)) }

  it { should have_many :users }
  it { should have_many :services }
  it { should belong_to :business }

  context "with validations" do
    describe "uniqueness" do
      let(:name)     { "foo" }
      let(:business) { create(:business) }

      it "should prevent teams with the same name in the same business" do
        team_a = create(:team, name:, business:)

        expect {
          create(:team, name: team_a.name, business:)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end

      # rubocop:disable Rails/SkipsModelValidations
      it "prevents a second team from claiming to be the administrators" do
        subject.update_column(:administrators, true)

        new_team = build(:team, business: subject.business, administrators: true)
        expect(new_team.valid?).to be(false)
      end
      # rubocop:enable Rails/SkipsModelValidations
    end

    describe "email" do
      context "when present" do
        it "should be a valid email between 5 and 64 characters" do
          subject.email = "mkrisher@schemabook.com"

          expect(subject.valid?).to eq(true)

          subject.email = "m"
          expect(subject.valid?).to eq(false)
        end
      end

      context "when not present" do
        it "should be considered valid" do
          subject.email = nil

          expect(subject.valid?).to eq(true)
        end
      end
    end

    describe "channel" do
      context "when present" do
        it "should be a valid string between 2 and 64 characters" do
          subject.channel = "team_red"
          expect(subject.valid?).to eq(true)

          subject.channel = "m"
          expect(subject.valid?).to eq(false)
        end
      end

      context "when not present" do
        it "should be considered valid" do
          subject.channel = nil

          expect(subject.valid?).to eq(true)
        end
      end
    end

  end

  context "callbacks" do
    context "before_save" do
      # rubocop:disable Rails/SkipsModelValidations
      it "prevents the admin team name from being mutated" do
        subject.update_column(:administrators, true)

        subject.name = "foo"
        subject.save
        subject.reload

        expect(subject.name).to eq(Team::ADMIN_TEAM_NAME)
      end
      # rubocop:enable Rails/SkipsModelValidations
    end
  end

  describe "#admin?" do
    context "when the administrators attribute is true" do
      it "returns true" do
        subject.administrators = true

        expect(subject.admin?).to be(true)
      end
    end
  end
end
