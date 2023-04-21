require 'rails_helper'

RSpec.describe "Services", type: :request do
  let(:business) { create(:business, :with_activity_log) }
  let(:team)     { create(:team, business:) }
  let!(:user)    { create(:user, business:) }
  let(:service)  { create(:service, team:, created_by: user.id) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      service.save

      get services_url

      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get service_url(service)

      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_service_url

      expect(response).to be_successful
    end

    it "flashes a message if unpaid and at limit" do
      stub_const("Service::UNPAID_LIMIT", 1)
      _service = create(:service, team: user.team, created_by: user.id)

      get new_service_url

      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to match(/You've reached the limits/)
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      get edit_service_url(service)

      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Service" do
        expect {
          post services_url, params: { service: { name: "foo" } }
        }.to change(Service, :count).by(1)
      end

      it "publishes an event" do
        expect_any_instance_of(Events::Services::Created).to receive(:publish)

        post services_url, params: { service: { name: "foo" } }
      end

      it "redirects to the created service" do
        post services_url, params: { service: { name: "bar" } }

        expect(response).to redirect_to(service_url(Service.last))
      end
    end

    context "with invalid parameters" do
      before do
        create(:service, team: user.team, created_by: user.id, name: "foo")
      end

      it "does not create a new Service" do
        expect {
          post services_url, params: { service: { name: "foo" } }
        }.not_to change(Service, :count)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post services_url, params: { service: { name: "foo" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).not_to be_successful
      end
    end

    context "when unpaid and at limit" do
      it "guards against new services being created" do
        stub_const("Service::UNPAID_LIMIT", 1)
        _service = create(:service, team: user.team, created_by: user.id)

        expect {
          post services_url, params: { service: { name: "foo" } }
        }.not_to change(Service, :count)

        expect(response).to have_http_status(:ok)
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to match(/You've reached the limits/)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { name: "new name" }
      }

      it "updates the requested service" do
        patch service_url(service), params: { service: new_attributes }

        service.reload

        expect(service.name).to eq("new name")
      end

      it "redirects to the service" do
        patch service_url(service), params: { service: new_attributes }

        service.reload

        expect(response).to redirect_to(service_url(service))
      end
    end

    context "with invalid parameters" do
      let!(:service) { create(:service, team: user.team, created_by: user.id, name: "bar") }

      before do
        create(:service, team: user.team, created_by: user.id, name: "foo")
      end

      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch service_url(service), params: { service: { name: "foo" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).not_to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      service.save
    end

    it "destroys the requested service" do
      expect {
        delete service_url(service)
      }.to change(Service, :count).by(-1)
    end

    it "redirects to the services list" do
      delete service_url(service)

      expect(response).to redirect_to(services_url)
    end
  end
end
