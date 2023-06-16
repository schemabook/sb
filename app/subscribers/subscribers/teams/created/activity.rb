module Subscribers
  module Teams
    module Created
      class Activity
        include Subscribers::Subscriber

        EVENT_NAME = Events::Teams::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          team    = Team.where(id: payload.after.id).first
          log     = team.business.activity_log
          user    = User.find(payload.after.actor)

          create_activity(log:, team:, user:)
        end

        private

        def create_activity(log:, team:, user:)
          ::Activity.where(
            activity_log: log,
            user:,
            title: "Created Team",
            detail: "Establisheded team #{team.name}",
            resource_id: team.id,
            resource_class: team.class.to_s
          ).first_or_create
        end
      end
    end
  end
end
