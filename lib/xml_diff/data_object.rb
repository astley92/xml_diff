# frozen_string_literal: true

class XmlDiff::DataObject
  attr_reader :identifier, :type, :attributes

  def self.from_hash(hash_obj, data_type)
    identifier = data_type.identifier_attributes.map { |attr| hash_obj[attr] }.join("-")
    new(
      identifier:,
      type: data_type.type,
      attributes: hash_obj,
    )
  end

  def to_h
    attributes.merge(type:)
  end

  def ==(other)
    identifier == other.identifier && type == other.type && attributes == other.attributes
  end

  private

  def initialize(identifier:, type:, attributes:)
    @identifier = identifier
    @type = type
    @attributes = attributes
  end
end
