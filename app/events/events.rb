class InvalidEventPayloadError < StandardError; end

module Events
  module Event
    extend self

    def payload
      {}
    end

    # NOTE: payload delivered as a Ruby hash, possibly serialized in the future
    def publish
      if valid_payload?

        ActiveSupport::Notifications.instrument(self.class::EVENT_NAME, payload)
      else
        error = InvalidEventPayloadError.new("#{self.class::EVENT_NAME} payload is invalid")

        Rails.logger.warn "event #{self.class::EVENT_NAME} payload is invalid"

        raise error unless Rails.env.production?
      end
    end

    def valid_payload?
      Avro::Schema.validate(encoded_schema, payload)
    end

    def encoded_schema
      Avro::Schema.parse(schema)
    end
  end
end
