# frozen_string_literal: true

module XmlDiff::Diff::Generator
  def self.run(inspector, data_one, data_two)
    diff = XmlDiff::Diff.new

    first_inspection = inspector.call(data_one)
    second_inspection = inspector.call(data_two)

    inspector.data_types.each do |data_type|
      first_objects = first_inspection.objects_of_type(data_type.type)
      second_objects = second_inspection.objects_of_type(data_type.type)

      first_objects.each do |first_object|
        second_object = second_objects.find_by_identifier(first_object.identifier)
        second_objects.delete(second_object) unless second_object.nil?

        if second_object.nil?
          diff.deletions << first_object
        elsif second_object != first_object
          diff.changes << first_object
        end
      end

      second_objects.each do |second_object|
        diff.additions << second_object
      end
    end

    diff
  end
end
