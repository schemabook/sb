require 'rails_helper'

RSpec.describe "/schemas/:id/comments", type: :request do
  let(:user)   { create(:user, :admin) }
  let(:schema) { create(:schema, :with_team, :with_format) }
  let(:version) { create(:version, schema:) }
  let(:comment) { build(:comment, version:, user:) }

  let(:valid_attributes) {
    { "body" => "this is a comment", "version_id" => version.id, "user_id" => user.id }
  }

  let(:invalid_attributes) {
    { "foo" => "bar", "version_id" => version.id, "user_id" => user.id }
  }

  before do
    sign_in user
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a comment" do
        expect {
          post schema_version_comments_path(schema, version), params: { comment: valid_attributes }
        }.to change(Comment, :count).by(1)
      end

      it "publishes an event" do
        expect_any_instance_of(Events::Comments::Created).to receive(:publish)

        post schema_version_comments_path(schema, version), params: { comment: valid_attributes }
      end

      it "redirects to the associated schema" do
        post schema_version_comments_path(schema, version), params: { comment: valid_attributes }

        expect(flash[:notice]).to be_present
        expect(response).to redirect_to(schema_url(comment.version.schema, version: version.id))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Comment" do
        expect {
          post schema_version_comments_path(schema, version), params: { comment: invalid_attributes }
        }.not_to change(Comment, :count)
      end

      it "redirects to the schema page with a message" do
        post schema_version_comments_path(schema, version), params: { comment: invalid_attributes }

        expect(flash[:alert]).to be_present
        expect(response).to redirect_to(schema_url(comment.version.schema, version: version.id))
      end
    end
  end
end
