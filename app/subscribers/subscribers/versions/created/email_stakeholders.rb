module Subscribers
  module Versions
    module Created
      class EmailStakeholders
        include Subscribers::Subscriber

        EVENT_NAME = Events::Versions::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          version = Version.where(id: payload.after.id).first
          user    = User.find(payload.after.actor)

          UserMailer.with(version:, user:).new_version_email.deliver_now
        end
      end
    end
  end
end
