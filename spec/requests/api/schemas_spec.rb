require 'swagger_helper'

RSpec.describe 'api/schemas', type: :request do
  let(:schema) { create(:schema, :with_format, :with_team, description: "lorem ipsum") }
  let(:user) { create(:user, team: schema.team, business: schema.team.business) }
  let(:email) { user.email }
  let(:"x-api-token") { user.api_token }

  path '/api/schemas' do
    get('list schemas') do
      parameter name: :"x-api-token", in: :header, type: :string

      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        
        run_test!
      end
    end
  end
end
