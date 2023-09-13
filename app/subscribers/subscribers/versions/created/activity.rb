module Subscribers
  module Versions
    module Created
      class Activity
        include Subscribers::Subscriber

        EVENT_NAME = Events::Versions::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          version = Version.where(id: payload.after.id).first
          user    = User.find(payload.after.actor)
          log     = user.business.activity_log

          create_activity(log:, version:, user:)
        end

        private

        def create_activity(log:, version:, user:)
          ::Activity.where(
            activity_log: log,
            user:,
            title: "Created Version",
            detail: "Created version #{version.index} for #{version.schema.name}",
            resource_id: version.id,
            resource_class: version.class.to_s
          ).first_or_create
        end
      end
    end
  end
end
