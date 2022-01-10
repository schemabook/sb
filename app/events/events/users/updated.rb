module Events
  module Users
    class Updated
      include Events::Event

      EVENT_NAME    = "updated.user".freeze
      EVENT_VERSION = "0.1".freeze

      attr_accessor :user

      def initialize(user:)
        @user     = user
      end

      # rubocop:disable Metrics/MethodLength
      def schema
        Avro::Builder.build do
          namespace EVENT_NAME

          record :user do
            required :before, :record do
              required :team_id, :int
            end

            required :after, :record do
              required :team_id, :int
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
            team_id: @user.team.id
          },
          after: {
            team_id: @user.team.id
          },
          source: {
            version: EVENT_VERSION,
            name: EVENT_NAME,
            ts_ms: (@user.created_at.to_f * 1000).to_i,
            table: @user.class.table_name
          },
          op: 'u',
          ts_ms: (Time.zone.now.to_f * 1000).to_i
        }
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
