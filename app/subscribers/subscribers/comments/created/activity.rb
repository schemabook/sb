module Subscribers
  module Comments
    module Created
      class Activity
        include Subscribers::Subscriber

        EVENT_NAME = Events::Comments::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          comment = Comment.find(payload.after.id)
          user    = User.find(payload.after.actor_id)
          version = comment.version

          ::Activity.where(
            activity_log: user.business.activity_log,
            user:,
            title: "Comment Created",
            detail: "Created comment #{comment.id} on #{version.schema.name} version #{version.id}",
            resource_id: version.id,
            resource_class: version.class.to_s
          ).first_or_create
        end
      end
    end
  end
end
