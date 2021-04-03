 require 'rails_helper'

RSpec.describe "businesses", type: :request do
  describe "GET /show" do
    it "renders a successful response" do
      business = create(:business)
      get business_url(business)

      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      business = create(:business)
      get edit_business_url(business)

      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested business" do
        business = create(:business)
        patch business_url(business), params: { business: {name: 'new name'} }
        business.reload

        expect(business.name).to eq('new name')
      end

      it "redirects to the business" do
        business = create(:business)
        patch business_url(business), params: { business: {name: 'new name'} }
        business.reload

        expect(response).to redirect_to(business_url(business))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        business = create(:business)
        patch business_url(business), params: { business: {foo: 'bar'} }

        expect(response.status).to eq(302)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested business" do
      business = create(:business)
      expect {
        delete business_url(business)
      }.to change(Business, :count).by(-1)
    end
  end
end
