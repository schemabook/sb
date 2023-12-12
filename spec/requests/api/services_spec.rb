require 'swagger_helper'

# rubocop:disable RSpec/VariableName
RSpec.describe 'api/services', type: :request do
  let!(:user) { create(:user) }
  let!(:service) { create(:service, team: user.team, created_by: user.id) }
  let(:email) { user.email }
  let(:'x-api-token') { user.api_token }

  before do
    allow(ActiveSupport::Deprecation).to receive(:warn) # Silence deprecation output from specs
  end

  path '/api/services' do
    get('list services') do
      tags 'Services'
      description 'Retrieves all services for the given user'
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
