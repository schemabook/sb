module Subscribers
  module Invitations
    module Created
      class Activity
        include Subscribers::Subscriber

        EVENT_NAME = Events::Invitations::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload  = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          teammate = User.find(payload.after.id)
          user     = User.find(payload.after.actor_id)
          log      = ::ActivityLog.first_or_create(business_id: user.business.id)

          ::Activity.where(
            activity_log: log,
            user:,
            title: "Invited Teammate",
            detail: "#{user.display_name} invited #{teammate.display_name}",
            resource_id: teammate.id,
            resource_class: teammate.class.to_s
          ).first_or_create
        end
      end
    end
  end
end
