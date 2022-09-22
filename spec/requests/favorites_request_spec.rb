require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let!(:business) { create(:business, :with_activity_log) }
  let!(:user)     { create(:user, business:) }
  let!(:schema)   { create(:schema, :with_team, :with_format) }

  before do
    sign_in user
  end

  describe "POST create" do
    let(:params) { { favorite: { schema_id: schema.id, user_id: user.id } } }

    subject { post favorites_path(params) }

    it "create a favorite" do
      expect {
        subject
      }.to change(Favorite, :count)
    end

    it "sets a flash message" do
      subject

      expect(flash[:notice]).to match(/starred/)
    end
  end

  describe "DELETE destroy" do
    let!(:favorite) { create(:favorite, schema_id: schema.id, user_id: user.id) }
    let(:params) { { favorite: { schema_id: schema.id, user_id: user.id } } }

    subject { delete favorites_path(params) }

    it "destroys a favorite" do
      expect {
        subject
      }.to change(Favorite, :count)
    end

    it "sets a flash message" do
      subject

      expect(flash[:notice]).to match(/unstarred/)
    end
  end
end
