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

          create_activity_for_user(log:, stakeholder:, user:)
          create_activity_for_schema(log:, stakeholder:, user:)
        end

        private

        def create_activity_for_user(log:, stakeholder:, user:)
          ::Activity.create(
            activity_log: log,
            user:,
            title: "Became Stakeholder",
            detail: "Established for #{stakeholder.schema.name}",
            resource_id: stakeholder.user.id,
            resource_class: stakeholder.user.class.to_s,
            user_only: true
          )
        end

        def create_activity_for_schema(log:, stakeholder:, user:)
          ::Activity.create(
            activity_log: log,
            user:,
            title: "Created Stakeholder",
            detail: "Established for #{stakeholder.user.name}",
            resource_id: stakeholder.schema.id,
            resource_class: stakeholder.schema.class.to_s
          )
        end
      end
    end
  end
end
