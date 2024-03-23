# frozen_string_literal: true

require("nokogiri")

class XmlDiff::Inspector
  MissingIdentifierAttributeError = Class.new(StandardError)
  AmbiguousIdentifierAttributeError = Class.new(StandardError)

  attr_reader :data_objects

  def initialize
    @data_types = []
    @data_objects = []
  end

  def add_data_type(type:, document_path:, attributes:, identifier_attributes:)
    @data_types << DataType.new(
      type:,
      document_path:,
      attributes:,
      identifier_attributes:,
    )
  end

  def call(xml)
    doc = Nokogiri::XML(xml)
    @data_types.each do |data_type|
      doc.css(data_type.document_path).each do |node|
        data_object = { type: data_type.type }
        data_type.attributes.each do |attribute|
          attr_text = if data_type.identifier_attributes.include?(attribute)
                        extract_identifier_attr!(attribute, data_type, node)
                      else
                        node.css(attribute.to_s).text
                      end

          data_object[attribute] = attr_text.empty? ? nil : attr_text
        end
        @data_objects << data_object
      end
    end
    self
  end

  private

  def extract_identifier_attr!(attribute, data_type, node)
    attr_nodes = node.css(attribute.to_s)
    if attr_nodes.count.zero?
      handle_missing_identifier_attr!(attribute, data_type.type)
    elsif attr_nodes.count > 1
      handle_amiguous_identifier_attr!(attribute, data_type)
    end

    node.css(attribute.to_s).text
  end

  def handle_missing_identifier_attr!(attribute, data_type)
    raise(MissingIdentifierAttributeError, <<~MSG.strip)
      #{data_type} data type was found, but identifier attribute `#{attribute}` was not present.
    MSG
  end

  def handle_amiguous_identifier_attr!(attribute, data_type)
    raise(AmbiguousIdentifierAttributeError, <<~MSG.strip)
      #{data_type.type} data type was found, but identifier attribute `#{attribute}` was not unique.
    MSG
  end
end
