# frozen_string_literal: true

require("nokogiri")

class XmlDiff::Inspector
  MissingIdentifierAttributeError = Class.new(StandardError)

  attr_reader :data_objects

  def initialize
    @data_types = []
    @data_objects = []
  end

  def add_data_type(type:, css_path:, attributes:, identifier_attributes:)
    @data_types << DataType.new(
      type:,
      css_path:,
      attributes:,
      identifier_attributes:,
    )
  end

  def call(xml)
    doc = Nokogiri::XML(xml)
    @data_types.each do |data_type|
      doc.css(data_type.css_path).each do |node|
        data_object = { type: data_type.type }
        data_type.attributes.each do |attribute|
          attr_text = node.css(attribute.to_s).text
          if data_type.identifier_attributes.include?(attribute)
            ensure_identifier_attr_present!(attr_text, attribute, data_type)
          end

          data_object[attribute] = attr_text.empty? ? nil : attr_text
        end
        @data_objects << data_object
      end
    end
    self
  end

  private

  def ensure_identifier_attr_present!(attr_text, attribute, data_type)
    return unless attr_text.empty?

    raise(MissingIdentifierAttributeError, <<~MSG.strip)
      #{data_type.type} data type was found, but identifier attribute `#{attribute}` was not present.
    MSG
  end
end
