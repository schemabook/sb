require 'rails_helper'

RSpec.describe "Devise", type: :request do
  describe "GET users/index" do
    subject { get user_root_path }

    it "should redirect to the dashboards index" do
      expect(subject).to redirect_to('/dashboards')
    end
  end
end
