# frozen_string_literal: true

require 'test_helper'

module DataExport
  module Handlers
    module DefaultHandlers
      class DefaultHandlersTest < ActiveSupport::TestCase
        setup do
          @service = DataExport::ExcelGeneratorService.new
        end

        test 'datetime_handler should return formated datetime, when have value' do
          assert @service.datetime_handler(DateTime.current) == DateTime.current.strftime('%d/%m/%Y %H:%M')
        end

        test 'datetime_handler should return empty string, when value is nil' do
          assert @service.datetime_handler(nil) == ''
        end

        test 'date_handler should return formated date, when have value' do
          assert @service.date_handler(Date.current) == Date.current.strftime('%d/%m/%Y')
        end

        test 'date_handler should return empty string, when value is nil' do
          assert @service.date_handler(nil) == ''
        end

        test 'array_handler should return joined array, when have value' do
          assert @service.array_handler([1, 2, 3]) == '1, 2, 3'
        end

        test 'array_handler should return empty array, when value is nil' do
          assert @service.array_handler(nil) == []
        end

        test 'integer_handler should return integer, when have value' do
          assert @service.integer_handler(1) == 1
        end

        test 'integer_handler should return empty string, when value is nil' do
          assert @service.integer_handler(nil) == ''
        end

        test 'text_handler should return text, when have value' do
          assert @service.text_handler('text') == 'text'
        end

        test 'text_handler should return empty string, when value is nil' do
          assert @service.text_handler(nil) == ''
        end

        test 'boolean_handler should return Sim, when value is true' do
          assert @service.boolean_handler(true) == 'Sim'
        end

        test 'boolean_handler should return Não, when value is false' do
          assert @service.boolean_handler(false) == 'Não'
        end

        test 'boolean_handler should return empty string, when value is nil' do
          assert @service.boolean_handler(nil) == ''
        end

        # rubocop:disable Lint/FloatComparison
        test 'decimal_handler should return decimal, when have value' do
          assert @service.decimal_handler(1.1) == 1.1
        end
        # rubocop:enable Lint/FloatComparison

        test 'decimal_handler should return empty string, when value is nil' do
          assert @service.decimal_handler(nil) == ''
        end

        test 'json_handler should return json, when have value' do
          assert @service.json_handler({ a: 1 }.to_json) == { a: 1 }.to_json
        end

        test 'json_handler should return empty json, when value is nil' do
          assert @service.json_handler(nil) == {}.to_json
        end

        test 'uuid_handler should return uuid, when have value' do
          uuid = SecureRandom.uuid
          assert @service.uuid_handler(uuid) == uuid
        end

        test 'uuid_handler should return empty string, when value is nil' do
          assert @service.uuid_handler(nil) == ''
        end

        test 'string_handler should return string, when have value' do
          assert @service.string_handler('string') == 'string'
        end

        test 'string_handler should return empty string, when value is nil' do
          assert @service.string_handler(nil) == ''
        end
      end
    end
  end
end
