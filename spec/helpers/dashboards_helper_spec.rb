require "rails_helper"

RSpec.describe DashboardsHelper, type: :helper do
  describe "#activity_title" do
    let(:resource) { create(:business, name: "foo") }
    let(:activity) { create(:activity, :with_activity_log, user: create(:user), resource_class: resource.class.to_s, resource_id: resource.id, title: "Created", detail: "bar") }

    it "returns the title including link to resource" do
      expect(helper.activity_title(activity)).to eq("Created <a class=\"text-sm text-cyan-600\" href=\"/businesses/#{resource.public_id}\">#{resource.name}</a>")
    end
  end
end
