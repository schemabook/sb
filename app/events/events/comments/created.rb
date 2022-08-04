module Events
  module Comments
    class Created
      include Events::Event

      EVENT_NAME    = "created.comment".freeze
      EVENT_VERSION = "0.1".freeze

      attr_accessor :comment

      def initialize(record:, user:)
        @comment = record
        @user    = user
      end

      # rubocop:disable Metrics/MethodLength
      def schema
        Avro::Builder.build do
          namespace EVENT_NAME

          record :comment do
            optional :before, :record

            required :after, :record do
              required :id, :int
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
          before: nil,
          after: {
            id: @comment.id,
            actor_id: @user.id
          },
          source: {
            version: EVENT_VERSION,
            name: EVENT_NAME,
            ts_ms: (@comment.created_at.to_f * 1000).to_i,
            table: @comment.class.table_name
          },
          op: 'c',
          ts_ms: (Time.zone.now.to_f * 1000).to_i
        }
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
