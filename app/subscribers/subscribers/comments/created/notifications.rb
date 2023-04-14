module Subscribers
  module Comments
    module Created
      class Notifications
        include Subscribers::Subscriber

        EVENT_NAME = Events::Comments::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          comment = Comment.find(payload.after.id)
          user = User.find(payload.after.actor_id)
          version = comment.version
          schema = version.schema
          team = schema.team

          UserMailer.with(user:, schema:, version:, team:, comment:).new_comment_email.deliver_now
        end
      end
    end
  end
end
