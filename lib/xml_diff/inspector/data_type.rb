# frozen_string_literal: true

class XmlDiff::Inspector::DataType
  attr_reader :type, :css_path, :attributes, :identifier_attributes

  def initialize(type:, css_path:, attributes: [], identifier_attributes: [])
    @type = type
    @css_path = css_path
    @attributes = attributes + identifier_attributes
    @identifier_attributes = identifier_attributes
  end
end
