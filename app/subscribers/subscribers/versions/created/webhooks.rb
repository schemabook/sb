module Subscribers
  module Versions
    module Created
      class Webhooks
        include Subscribers::Subscriber

        EVENT_NAME = Events::Versions::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          version = Version.where(id: payload.after.id).first
          webhooks = version.schema.webhooks

          webhooks.each do |webhook|
            request_webhook(webhook:)
          end

          return true
        end

        private

        # TODO: determine if the version is always latest of not
        def request_webhook(webhook:)
          url = webhook.url
          payload = webhook.payload

          response = HTTParty.post(url, payload)
          Rails.logger.info "webhook #{webhook.id} response code: #{response.code}"

          # Log the response, on the webhook so it can be displayed as success or failure
          webhook.update(response_code: response.code, response_body: response.body)
        end
      end
    end
  end
end
