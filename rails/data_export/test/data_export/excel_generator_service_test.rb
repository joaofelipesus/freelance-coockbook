# frozen_string_literal: true

# require 'minitest/autorun'
require 'mocha/minitest'
require 'axlsx'
require 'yaml'
require 'test_helper'
# require_relative 'excel_generator_service'

module DataExport
  class ExcelGeneratorServiceTest < ActiveSupport::TestCase
    setup do
      @service = ExcelGeneratorService.new
    end

    def test_self_call
      ExcelGeneratorService.any_instance.expects(:call).returns(:ok)
      assert_equal :ok, ExcelGeneratorService.call
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def test_call
      package_mock = mock('Axlsx::Package')
      workbook_mock = mock('Axlsx::Workbook')
      sheet_mock = mock('Axlsx::Worksheet')

      Axlsx::Package.expects(:new).yields(package_mock)
      package_mock.expects(:workbook).returns(workbook_mock)
      package_mock.expects(:serialize).with(instance_of(String))

      model_values = {
        'model_name' => 'TestModel',
        'attributes' => {
          'attr1' => {
            'skip' => false,
            'name' => 'Attribute 1',
            'handler' => 'default_handler'
          }
        }
      }

      @service.expects(:application_models).returns('Model' => model_values)
      workbook_mock.expects(:add_worksheet).with(name: 'TestModel').yields(sheet_mock)
      @service.expects(:add_header).with(sheet_mock,
                                         {
                                           'attr1' => {
                                             'skip' => false,
                                             'name' => 'Attribute 1',
                                             'handler' => 'default_handler'
                                           }
                                         })
      @service.expects(:add_rows).with(sheet_mock, 'Model', {
                                         'attr1' => {
                                           'skip' => false,
                                           'name' => 'Attribute 1',
                                           'handler' => 'default_handler'
                                         }
                                       })

      assert_equal :ok, @service.call
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def test_application_models
      YAML.expects(:load_file).with(SchemaGeneratorService::SCHEMA_PATH).returns('models' => 'test_models')
      assert_equal 'test_models', @service.application_models
    end

    def test_add_header
      sheet_mock = mock('Axlsx::Worksheet')
      sheet_mock.expects(:add_row).with(['Attribute 1'])
      @service.add_header(sheet_mock, { 'attr1' => { 'name' => 'Attribute 1' } })
    end
  end
end
