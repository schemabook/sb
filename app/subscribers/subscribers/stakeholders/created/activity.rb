module Subscribers
  module Stakeholders
    module Created
      class Activity
        include Subscribers::Subscriber

        EVENT_NAME = Events::Stakeholders::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload     = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          stakeholder = Stakeholder.where(id: payload.after.id).first
          user        = stakeholder.user
          log         = user.team.business.activity_log

          create_activity(log:, stakeholder:, user:)
        end

        private

        def create_activity(log:, stakeholder:, user:)
          ::Activity.create(
            activity_log: log,
            user:,
            title: "Created Stakeholder",
            detail: "Establisheded stakeholding for #{stakeholder.schema.name}",
            resource_id: stakeholder.id,
            resource_class: stakeholder.class.to_s
          )
        end
      end
    end
  end
end
