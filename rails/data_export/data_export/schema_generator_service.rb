# frozen_string_literal: true

module DataExport
  class SchemaGeneratorService
    CLASS_MATCH_REGULAR_EXPRESSION = /^\s*class\s+([A-Za-z0-9_:]+)/
    SCHEMA_PATH = 'db/export_schema.yml'

    # TODO: referece direct to service class methods that handle the attribute type.
    ATTRIBUTE_HANDLERS = {
      integer: 'integer_handler',
      string: 'string_handler',
      text: 'text_handler',
      datetime: 'datetime_handler',
      date: 'date_handler',
      decimal: 'decimal_handler',
      boolean: 'boolean_handler',
      array: 'array_handler'
    }.freeze

    IGNORED_ATTRIBUTES = %w[
      password_digest password encrypted_password last_sign_in_at last_sign_in_ip remember_created_at sign_in_count
      current_sign_in_ip current_sign_in_at
    ].freeze

    def self.call
      new.call
    end

    # Generate a YML file with the schema of the application models, for each attribute the follow keys are generated:
    # - name: the attribute name, if the attribute name is found in the I18n file, the translation is used.
    # - type: the attribute type.
    # - skip: a boolean value that indicates if the attribute should be skipped in the export.
    # - handler: the method that should be used to handle the attribute value.
    # rubocop:disable Metrics/MethodLength
    def call
      yml_file = File.open(SCHEMA_PATH, 'w')
      yml_file.puts 'models:'
      application_classes.each do |model|
        yml_file.puts "  #{model.name}:"
        yml_file.puts "    model_name: #{model.model_name.human}"
        yml_file.puts '    attributes:'
        handle_attributes(model:, yml_file:)
        yml_file.puts ''
      end

      yml_file.close
      :ok
    end
    # rubocop:enable Metrics/MethodLength

    private

    def model_files
      Dir.glob('app/models/**/*.rb')
    end

    def application_classes
      classes = model_files.map { |file| fetch_class_name(file) }
      classes -= ['ApplicationRecord']
      classes.compact.sort.map(&:constantize)
    end

    # NOTE: uses a regular expression to find the class name. Return nil if no class name is found, this behavior aims
    # to handle concerns and other files that are not models.
    def fetch_class_name(file)
      File.open(file, 'r') do |f|
        f.each_line { |line| return ::Regexp.last_match(1) if line =~ CLASS_MATCH_REGULAR_EXPRESSION }
      end

      nil
    end

    def fetch_attribute_name(attribute_name, model)
      model_name_key = model.name.underscore

      if I18n.exists?("activerecord.attributes.#{model_name_key}.#{attribute_name}")
        I18n.t("activerecord.attributes.#{model_name_key}.#{attribute_name}")
      else
        attribute_name
      end
    end

    # Array attributes are handled differently, the type is set to array and the handler is set to array_handler.
    def handle_attribute_type_and_handler(attribute:, yml_file:, model:)
      if model.columns_hash[attribute].type == :string && model.columns_hash[attribute].array
        yml_file.puts '        type: array'
        yml_file.puts '        handler: array_handler'
      else
        yml_file.puts "        type: #{model.columns_hash[attribute].type}"
        yml_file.puts "        handler: #{model.columns_hash[attribute].type}_handler"
      end
    end

    def handle_attributes(model:, yml_file:)
      model_attributes = model.column_names - IGNORED_ATTRIBUTES

      model_attributes.sort.each do |attribute|
        yml_file.puts "      #{attribute}:"
        yml_file.puts "        name: #{fetch_attribute_name(attribute, model)}"
        yml_file.puts '        skip: false'
        handle_attribute_type_and_handler(attribute:, yml_file:, model:)
      end
    end
  end
end
