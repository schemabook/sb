require 'rails_helper'

RSpec.describe "Versions", type: :request do
  let!(:business) { create(:business, :with_activity_log) }
  let!(:user)     { create(:user, business:) }
  let!(:schema)   { create(:schema, :with_team, :with_format) }

  before do
    sign_in user
  end

  describe "GET new" do
    subject { get new_schema_version_path(schema) }

    it "should assign schema" do
      subject

      expect(assigns(:schema).class).to eq(Schema)
    end

    context "when the current user is not a member of the schema's team" do
      it "should redirect back to the schema page" do
        subject

        expect(response).to redirect_to(schema_path(schema))
      end
    end

    context "when the current user is a member of the schema's team" do
      before do
        schema.team.users << user
      end

      it "should render the form" do
        subject

        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST create" do
    subject { post schema_versions_path(schema), params: { version: { body: "{}" } } }

    context "when current user is a member of the schema's team" do
      before do
        schema.team.users << user
      end

      it "should assign schema" do
        subject

        expect(assigns(:schema).class).to eq(Schema)
      end

      it "should save a new version" do
        expect {
          subject
        }.to change(Version, :count)
      end

      it "should broadcast an event" do
        expect_any_instance_of(Events::Versions::Created).to receive(:publish)

        subject
      end

      it "should redirect to the schema path" do
        subject

        expect(response).to redirect_to(schema_path(schema))
      end
    end

    context "when the current user is not a member of the schema's team" do
      it "should redirect back to the schema page" do
        subject

        expect(response).to redirect_to(schema_path(schema))
      end
    end
  end
end
