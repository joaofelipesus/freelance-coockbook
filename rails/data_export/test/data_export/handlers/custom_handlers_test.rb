# frozen_string_literal: true

require 'test_helper'

module DataExport
  module Handlers
    module CustomHandlers
      class CustomHandlersTest < ActiveSupport::TestCase
        setup do
          @service = DataExport::ExcelGeneratorService.new
        end

        test 'patient_name_handler should return name with initials, when have value' do
          assert @service.patient_name_handler('John Doe') == 'J. D.'
        end

        test 'patient_name_handler should return empty string, when value is nil' do
          assert @service.patient_name_handler(nil) == ''
        end
      end
    end
  end
end
