require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let!(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET index" do
    subject { get dashboards_path }

    it "should render the template" do
      expect(subject).to render_template(:index)
    end
  end
end
