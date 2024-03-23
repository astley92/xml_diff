# frozen_string_literal: true

require("nokogiri")

class XmlDiff::Inspector
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
          data_object[attribute] = node.css(attribute.to_s).text
        end
        @data_objects << data_object
      end
    end
    self
  end
end
