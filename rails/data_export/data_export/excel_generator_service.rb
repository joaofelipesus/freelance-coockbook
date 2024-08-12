# frozen_string_literal: true

module DataExport
  class ExcelGeneratorService
    include DataExport::Handlers::DefaultHandlers
    include DataExport::Handlers::CustomHandlers

    def self.call
      new.call
    end

    # rubocop:disable Metrics/MethodLength
    def call
      Axlsx::Package.new do |package|
        application_models.each do |model, configs|
          package.workbook.add_worksheet(name: configs['model_name']) do |sheet|
            valid_attributes = configs['attributes'].select { |_k, v| v['skip'] == false }.to_h
            add_header(sheet, valid_attributes)
            add_rows(sheet, model, valid_attributes)
          end
        end

        package.serialize(file_name)
      end

      :ok
    end
    # rubocop:enable Metrics/MethodLength

    def file_name
      timestamp = Time.zone.now.strftime('%Y-%m-%d-%H-%M')
      Rails.root.join('tmp', "report_#{timestamp}.xlsx").to_s
    end

    def application_models
      YAML.load_file(SchemaGeneratorService::SCHEMA_PATH)['models']
    end

    def add_header(sheet, valid_attributes)
      sheet.add_row(valid_attributes.map { |_k, v| v['name'] })
    end

    def add_rows(sheet, model, valid_attributes)
      model.constantize.find_each do |item|
        row_values = valid_attributes.map do |attribute, configs|
          send(configs['handler'], item.send(attribute))
        end

        sheet.add_row row_values
      end
    end
  end
end
