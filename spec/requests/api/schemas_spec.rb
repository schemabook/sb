require 'swagger_helper'

# rubocop:disable RSpec/VariableName
RSpec.describe 'api/schemas', type: :request do
  let!(:schema) { create(:schema, :with_format, :with_team, description: "lorem ipsum") }
  let!(:user) { create(:user, team: schema.team, business: schema.team.business) }
  let(:email) { user.email }
  let(:'x-api-token') { user.api_token }

  before do
    allow(ActiveSupport::Deprecation).to receive(:warn) # Silence deprecation output from specs
  end

  path '/api/schemas' do
    get('list schemas') do
      tags 'Schemas'
      description 'Retrieves all schemas for the given user'
      produces 'application/json'

      response(200, 'Successful') do
        parameter name: :'x-api-token', in: :header, type: :string

        run_test!
      end

      response(401, 'Unauthorized') do
        let(:'x-api-token') { nil }

        run_test!
      end
    end

    post 'create schema' do
      tags 'Schemas'
      description 'Creates a formatted schema associated with a given service'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :'x-api-token', in: :header, type: :string
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string},
          service_id: {type: :string},
          production: {type: :boolean},
          format: {type: :string},
          body: {type: :string}
        }
      }

      response(201, 'Successful') do
        let(:name) { 'my_schema' }
        let(:service_id) { create(:service, created_by: user.id, team: user.team).public_id }
        let(:production) { 'false' }
        let(:format) { 'json' }
        let(:body) { '{"foo": {"bar": 1}}' }

        let(:params) {
          {
            name:,
            service_id:,
            production:,
            format:,
            body:
          }
        }

        run_test!
      end

      response(401, 'Unauthorized') do
        let(:'x-api-token') { nil }

        let(:name) { 'my_schema' }
        let(:service_id) { create(:service, created_by: user.id, team: user.team).public_id }
        let(:production) { 'false' }
        let(:format) { 'json' }
        let(:body) { '{"foo": {"bar": 1}}' }

        let(:params) {
          {
            name:,
            service_id:,
            production:,
            format:,
            body:
          }
        }

        run_test!
      end
    end
  end

  path '/api/schemas/{id}' do
    parameter name: :id, in: :path, type: :string

    let(:id) { schema.public_id }

    get('schema') do
      tags 'Schemas'
      description 'Retrieves a specific schema by id'
      produces 'application/json'

      parameter name: :'x-api-token', in: :header, type: :string

      response(200, 'Successful') do
        run_test!
      end
    end
  end

  after do |example|
    if example.metadata[:response][:status_code] == 200
      example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
      }
    end

    content = example.metadata[:response][:content] || {}
    example_spec = {
      'application/json': {
        examples: {
          test_example: {
            value: JSON.parse(response.body, symbolize_names: true)
          }
        }
      }
    }
    example.metadata[:response][:content] = content.deep_merge(example_spec)
  end
end
# rubocop:enable RSpec/VariableName
