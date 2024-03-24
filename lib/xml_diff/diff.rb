# frozen_string_literal: true

class XmlDiff::Diff
  attr_reader :additions, :deletions, :changes

  def initialize
    @additions = []
    @deletions = []
    @changes = []
  end
end
