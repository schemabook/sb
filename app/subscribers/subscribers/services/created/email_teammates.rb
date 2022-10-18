module Subscribers
  module Services
    module Created
      class EmailTeammates
        include Subscribers::Subscriber

        EVENT_NAME = Events::Services::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          service = Service.where(id: payload.after.id).first
          user    = User.find(payload.after.actor)

          UserMailer.with(service:, user:).new_service_email.deliver_now
        end
      end
    end
  end
end
