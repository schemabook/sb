module Subscribers
  module Businesses
    module Updated
      class ActivityLog
        include Subscribers::Subscriber

        EVENT_NAME = Events::Businesses::Updated::EVENT_NAME

        def initialize
          subscribe
        end

        # rubocop:disable Metrics/MethodLength
        def process(event:)
          payload  = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          business = Business.find(payload.after.id)
          user     = User.find(payload.after.actor_id)
          log      = ::ActivityLog.create(business:)

          Activity.create(
            activity_log: log,
            user:,
            title: "Updated Business",
            detail: "Updated account settings for #{business.name}",
            resource_id: business.id,
            resource_class: business.class.to_s
          )
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
