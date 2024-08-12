# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'
require 'mocha/minitest'

module DataExport
  class MockUser
    def self.name
      'MockUser'
    end

    def self.column_names
      %i[name occupations]
    end

    # rubocop:disable Style/OpenStructUse
    def self.columns_hash
      {
        name: OpenStruct.new(type: :string),
        occupations: OpenStruct.new(type: :array)
      }
    end
    # rubocop:enable Style/OpenStructUse

    # rubocop:disable Style/OpenStructUse
    def self.model_name
      OpenStruct.new(human: 'Mock User')
    end
    # rubocop:enable Style/OpenStructUse
  end

  class SchemaGeneratorServiceTest < ActiveSupport::TestCase
    test 'should define CLASS_MATCH_REGULAR_EXPRESSION' do
      assert_equal(/^\s*class\s+([A-Za-z0-9_:]+)/, ::DataExport::SchemaGeneratorService::CLASS_MATCH_REGULAR_EXPRESSION)
    end

    test 'should define SCHEMA_PATH' do
      assert_equal('db/export_schema.yml', ::DataExport::SchemaGeneratorService::SCHEMA_PATH)
    end

    test 'should define ATTRIBUTE_HANDLERS' do
      assert_equal(
        {
          integer: 'integer_handler',
          string: 'string_handler',
          text: 'text_handler',
          datetime: 'datetime_handler',
          date: 'date_handler',
          decimal: 'decimal_handler',
          boolean: 'boolean_handler',
          array: 'array_handler'
        },
        ::DataExport::SchemaGeneratorService::ATTRIBUTE_HANDLERS
      )
    end

    test 'should define IGNORED_ATTRIBUTES' do
      assert_equal(
        %w[
          password_digest password encrypted_password last_sign_in_at last_sign_in_ip remember_created_at sign_in_count
          current_sign_in_ip current_sign_in_at
        ],
        ::DataExport::SchemaGeneratorService::IGNORED_ATTRIBUTES
      )
    end

    test 'should call generate yml file correctly' do
      # Open class to mock the application_classes method
      ::DataExport::SchemaGeneratorService.class_eval do
        def application_classes
          [MockUser]
        end
      end

      File.expects(:open).with('db/export_schema.yml', 'w').returns(mock_file = mock)

      mock_file.expects(:puts).with('models:')
      mock_file.expects(:puts).with('  MockUser:')
      mock_file.expects(:puts).with('    model_name: Mock User')
      mock_file.expects(:puts).with('    attributes:')
      mock_file.expects(:puts).with('      name:')
      mock_file.expects(:puts).with('        name: name')
      mock_file.expects(:puts).with('        skip: false')
      mock_file.expects(:puts).with('        type: string')
      mock_file.expects(:puts).with('        handler: string_handler')
      mock_file.expects(:puts).with('      occupations:')
      mock_file.expects(:puts).with('        name: occupations')
      mock_file.expects(:puts).with('        skip: false')
      mock_file.expects(:puts).with('        type: array')
      mock_file.expects(:puts).with('        handler: array_handler')
      mock_file.expects(:puts).with('')
      mock_file.expects(:close)

      service = ::DataExport::SchemaGeneratorService.new
      service.call
    end
  end
end
