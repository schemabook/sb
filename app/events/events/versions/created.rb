module Events
  module Versions
    class Created
      include Events::Event

      EVENT_NAME    = "created.version".freeze
      EVENT_VERSION = "0.1".freeze

      attr_accessor :record

      def initialize(record:, user: nil)
        @record = record
        @user   = user
      end

      # rubocop:disable Metrics/MethodLength
      def schema
        Avro::Builder.build do
          namespace EVENT_NAME

          record :version do
            optional :before, :record

            required :after, :record do
              required :id, :int
              required :schema, :int
              optional :actor, :int
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
          before: nil,
          after: {
            id: @record.id,
            schema: @record.schema.id,
            actor: @user&.id
          },
          source: {
            version: EVENT_VERSION,
            name: EVENT_NAME,
            ts_ms: (@record.created_at.to_f * 1000).to_i,
            table: @record.class.table_name
          },
          op: 'c',
          ts_ms: (Time.now.to_f * 1000).to_i
        }
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
