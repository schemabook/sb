module Events
  module Businesses
    class Updated
      include Events::Event

      EVENT_NAME    = "updated.business".freeze
      EVENT_VERSION = "0.1".freeze

      attr_accessor :business, :user

      def initialize(business:, user:)
        @business = business
        @user     = user
      end

      # rubocop:disable Metrics/MethodLength
      def schema
        Avro::Builder.build do
          namespace EVENT_NAME

          record :business do
            required :before, :record do
              required :id, :int
              required :name, :string
              optional :street_address, :string
              optional :city, :string
              optional :state, :string
              optional :postal, :string
              optional :country, :string
              required :actor_id, :int
            end

            required :after, :record do
              required :id, :int
              required :name, :string
              optional :street_address, :string
              optional :city, :string
              optional :state, :string
              optional :postal, :string
              optional :country, :string
              required :actor_id, :int
            end

            required :source, :record do
              required :version, :string
              required :name, :string
              required :ts_ms, :long, logical_type: 'timestamp-millis'
              required :table, :string
              optional :query, :string
            end

            required :op, :enum, symbols: [:c, :u, :d]
            required :ts_ms, :long, logical_type: 'timestamp-millis'
          end
        end
      end
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Metrics/MethodLength
      def payload
        {
          before: {
            id: @business.id,
            name: @business.name,
            street_address: @business.street_address,
            city: @business.city,
            state: @business.state,
            postal: @business.postal,
            country: @business.country,
            actor_id: @user.id
          },
          after: {
            id: @business.id,
            name: @business.name,
            street_address: @business.street_address,
            city: @business.city,
            state: @business.state,
            postal: @business.postal,
            country: @business.country,
            actor_id: @user.id
          },
          source: {
            version: EVENT_VERSION,
            name: EVENT_NAME,
            ts_ms: (@business.created_at.to_f * 1000).to_i,
            table: @business.class.table_name
          },
          op: 'c',
          ts_ms: (Time.zone.now.to_f * 1000).to_i
        }
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
