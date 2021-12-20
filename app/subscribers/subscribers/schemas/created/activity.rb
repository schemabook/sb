module Subscribers
  module Schemas
    module Created
      class Activity
        include Subscribers::Subscriber

        EVENT_NAME = Events::Schemas::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          _schema = Schema.where(id: payload.after.id).first

          # TODO: create ActivityLog Activity
        end
      end
    end
  end
end
