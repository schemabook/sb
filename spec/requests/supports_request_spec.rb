require "rails_helper"

RSpec.describe "Supports", type: :request do
  let!(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET index" do
    subject { get supports_path }

    it "should render the template" do
      expect(subject).to render_template(:index)
    end
  end
end
