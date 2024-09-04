require 'rails_helper'

RSpec.describe "Webhooks", type: :request do
  let!(:business) { create(:business, :with_activity_log) }
  let!(:user)     { create(:user, business:) }
  let!(:schema)   { create(:schema, :with_format, team: user.team) }

  before do
    sign_in user
  end

  describe "GET new" do
    subject { get new_schema_webhook_path(schema) }

    it "should assign schema" do
      subject

      expect(assigns(:schema).class).to eq(Schema)
    end

    context "when the current user is not a member of the schema's team" do
      let(:schema) { create(:schema, :with_team, :with_format) }

      it "should raise an error" do
        expect {
          subject
        }.to raise_error(ActiveRecord::RecordNotFound)
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
    subject { post schema_webhooks_path(schema), params: { webhook: { url: "https://example.com" } } }

    context "when current user is a member of the schema's team" do
      before do
        schema.team.users << user
      end

      it "should assign schema" do
        subject

        expect(assigns(:schema).class).to eq(Schema)
      end

      it "should save a new webhook" do
        expect {
          subject
        }.to change(Webhook, :count)
      end

      xit "should broadcast an event" do
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
