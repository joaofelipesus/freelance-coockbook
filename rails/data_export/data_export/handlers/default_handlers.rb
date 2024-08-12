# frozen_string_literal: true

module DataExport
  module Handlers
    module DefaultHandlers
      def datetime_handler(value)
        value&.strftime('%d/%m/%Y %H:%M') || ''
      end

      def date_handler(value)
        value&.strftime('%d/%m/%Y') || ''
      end

      def array_handler(value)
        value&.join(', ') || []
      end

      def uuid_handler(value)
        value || ''
      end

      def integer_handler(value)
        value || ''
      end

      def text_handler(value)
        value || ''
      end

      def boolean_handler(value)
        return '' if value.nil?

        value ? 'Sim' : 'Não'
      end

      def decimal_handler(value)
        value || ''
      end

      def json_handler(value)
        value || {}.to_json
      end

      def string_handler(value)
        value || ''
      end
    end
  end
end
