# frozen_string_literal: true

namespace :data_export do
  desc 'Generate schema'
  task generate_schema: :environment do
    DataExport::SchemaGeneratorService.call
  end

  desc 'Export dataset'
  task export_data: :environment do
    puts 'Exporting data...'
    DataExport::ExcelGeneratorService.call

    puts 'Attaching file to managers...'
    file = File.open(DataExport::ExcelGeneratorService.new.file_name)
    file_name = "report_#{Time.zone.now.strftime('%Y-%m-%d-%H-%M')}.xlsx"
    User.where(kind: :manager).each do |manager|
      manager.export_data.attach(io: File.open(DataExport::ExcelGeneratorService.new.file_name), filename: "report_#{Time.zone.now.strftime('%Y-%m-%d-%H-%M')}.xlsx")
    end
    puts 'Data exported successfully!'
  end
end
