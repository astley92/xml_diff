# frozen_string_literal: true

class XmlDiff::ObjectCollection
  include Enumerable

  def initialize(objects = [])
    @objects = objects
  end

  def <<(object)
    @objects << object
  end

  def each(&)
    @objects.each(&)
  end

  def select(&)
    self.class.new(@objects.select(&))
  end

  def find_by_identifier(identifier)
    find { |object| object.identifier == identifier }
  end

  def objects_of_type(type)
    select { |object| object.type == type }
  end

  def empty?
    @objects.empty?
  end

  def delete(object)
    @objects.delete(object)
  end
end
