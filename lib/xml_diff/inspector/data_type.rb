# frozen_string_literal: true

module XmlDiff
  class Inspector
    class DataType
      attr_reader :type, :document_path, :attributes, :identifier_attributes

      def initialize(type:, document_path:, attributes: [], identifier_attributes: [])
        @type = type
        @document_path = document_path
        @attributes = (attributes + identifier_attributes).uniq
        @identifier_attributes = identifier_attributes
      end
    end
  end
end
