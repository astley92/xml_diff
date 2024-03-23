# frozen_string_literal: true

RSpec.describe XmlDiff do
  describe "VERSION" do
    it "is the expected version" do
      expect(XmlDiff::VERSION).to eq("0.1.0")
    end
  end
end
