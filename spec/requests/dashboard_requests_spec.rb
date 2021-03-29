require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  describe "GET index" do
    subject { get dashboards_path }

    it "should render the template" do
      expect(subject).to render_template(:index)
    end
  end
end
