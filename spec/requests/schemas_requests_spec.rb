require 'rails_helper'

RSpec.describe "/schemas", type: :request do
  let(:user)    { create(:user, :admin) }
  let(:service) { create(:service, team: user.team, created_by: user.id) }
  let(:format)  { create(:format) }
  let(:schema)  { create(:schema, format:, team: user.team, name: "schema", service_id: service.id) }
  let!(:version) { create(:version, schema:, body: "{}") }

  let(:valid_attributes) {
    { "name" => "schema 1", "file_type" => "json", team_id: user.team_id, service_id: service.id, body: '[1]' }
  }

  let(:invalid_attributes) {
    { "foo" => "bar" }
  }

  before do
    sign_in user
  end

  describe "GET /show" do
    it "renders a successful response" do
      get schema_url(schema)

      expect(response).to be_successful
    end

    it "assigns activities" do
      get schema_url(schema)

      expect(assigns(:activities)).not_to be_nil
    end

    it "assigns stakeholder" do
      get schema_url(schema)

      expect(assigns(:stakeholder).class).to eq(Stakeholder)
    end

    it "assigns stakeholders" do
      get schema_url(schema)

      expect(assigns(:stakeholders)).to match_array([])
    end

    it "assigns a version" do
      get schema_url(schema)

      expect(assigns(:version).class).to eq(Version)
    end

    it "assigns a comment" do
      get schema_url(schema)

      expect(assigns(:comment).class).to eq(Comment)
    end

    it "assigns comments" do
      get schema_url(schema)

      expect(assigns(:comments)).to match_array([])
    end

    it "assigns the presenters" do
      get schema_url(schema)

      expect(assigns(:json_presenter).class).to eq(JsonPresenter)
      expect(assigns(:csv_presenter).class).to eq(CsvPresenter)
      expect(assigns(:avro_presenter).class).to eq(AvroPresenter)
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_schema_url

      expect(response).to be_successful
    end

    it "assigns activities" do
      get new_schema_url

      expect(assigns(:activities)).not_to be_nil
    end

    it "flashes a message if unpaid and at limit" do
      stub_const("Schema::UNPAID_LIMIT", 1)
      _schema = create(:schema, :with_format, team: user.team)

      get new_schema_url

      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to match(/You've reached the limits/)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a format" do
        expect {
          post schemas_url, params: { schema: valid_attributes }
        }.to change(Format, :count).by(1)
      end

      it "creates a new Schema" do
        expect {
          post schemas_url, params: { schema: valid_attributes }
        }.to change(Schema, :count).by(1)
      end

      it "associates the schema with the format" do
        post schemas_url, params: { schema: valid_attributes }

        schema = assigns(:schema)
        format = assigns(:format)

        expect(schema.format).to eq(format)
      end

      it "publishes an event" do
        expect_any_instance_of(Events::Schemas::Created).to receive(:publish)

        post schemas_url, params: { schema: valid_attributes }
      end

      it "redirects to the created schema" do
        post schemas_url, params: { schema: valid_attributes }

        expect(response).to redirect_to(schema_url(Schema.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Schema" do
        expect {
          post schemas_url, params: { schema: invalid_attributes }
        }.not_to change(Schema, :count)
      end

      it "renders an unprocessable_entity response (i.e. to display the 'new' template)" do
        post schemas_url, params: { schema: invalid_attributes }

        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
    end

    context "when unpaid and at limit" do
      it "guards against new services being created" do
        stub_const("Schema::UNPAID_LIMIT", 1)
        _schema = create(:schema, :with_format, team: user.team)

        expect {
          post schemas_url, params: { schema: valid_attributes }
        }.not_to change(Schema, :count)

        expect(response).to have_http_status(:ok)
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to match(/You've reached the limits/)
      end
    end
  end
end
