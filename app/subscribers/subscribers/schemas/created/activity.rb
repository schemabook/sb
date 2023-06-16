module Subscribers
  module Schemas
    module Created
      class Activity
        include Subscribers::Subscriber

        EVENT_NAME = Events::Schemas::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          schema  = Schema.where(id: payload.after.id).first
          user    = User.find(payload.after.actor)
          log     = user.business.activity_log

          create_activity(log:, schema:, user:)
        end

        private

        def create_activity(log:, schema:, user:)
          ::Activity.where(
            activity_log: log,
            user:,
            title: "Created Schema",
            detail: "Created schema #{schema.name}",
            resource_id: schema.id,
            resource_class: schema.class.to_s
          ).first_or_create
        end
      end
    end
  end
end
