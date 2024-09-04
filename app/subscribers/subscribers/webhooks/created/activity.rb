module Subscribers
  module Webhooks
    module Created
      class Activity
        include Subscribers::Subscriber

        EVENT_NAME = Events::Webhooks::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          webhook = Webhook.where(id: payload.after.id).first
          user    = User.find(payload.after.actor)
          log     = user.business.activity_log

          create_activity(log:, webhook:, user:)
        end

        private

        def create_activity(log:, webhook:, user:)
          ::Activity.where(
            activity_log: log,
            user:,
            title: "Created Webhook",
            detail: "Created webhook #{webhook.index} for #{webhook.schema.name}",
            resource_id: webhook.id,
            resource_class: webhook.class.to_s
          ).first_or_create
        end
      end
    end
  end
end
