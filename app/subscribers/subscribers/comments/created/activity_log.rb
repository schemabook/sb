module Subscribers
  module Comments
    module Created
      class ActivityLog
        include Subscribers::Subscriber

        EVENT_NAME = Events::Comments::Created::EVENT_NAME

        def initialize
          subscribe
        end

        # rubocop:disable Metrics/MethodLength
        def process(event:)
          payload = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          comment = Comment.find(payload.after.id)
          user    = User.find(payload.after.actor_id)
          schema  = comment.schema

          Activity.create(
            activity_log: user.business.activity_log,
            user:,
            title: "Created Comment",
            detail: "Commented on #{schema.name}",
            resource_id: schema.id,
            resource_class: schema.class.to_s
          )
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
