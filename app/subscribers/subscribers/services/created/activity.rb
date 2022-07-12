module Subscribers
  module Services
    module Created
      class Activity
        include Subscribers::Subscriber

        EVENT_NAME = Events::Services::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          service = Service.where(id: payload.after.id).first
          log     = service.team.business.activity_log
          user    = User.find(payload.after.actor)

          create_activity(log:, service:, user:)
        end

        private

        def create_activity(log:, service:, user:)
          ::Activity.create(
            activity_log: log,
            user:,
            title: "Created Service",
            detail: "Establisheded service for #{service.team.name}",
            resource_id: service.id,
            resource_class: service.class.to_s
          )
        end
      end
    end
  end
end
