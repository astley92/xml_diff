# frozen_string_literal: true

RSpec.describe XmlDiff::Inspector do
  subject(:inspector) { described_class.new }

  describe "#call" do
    subject(:result) { inspector.call(xml) }
    let(:xml) { <<~XML }
      <movies>
        <movie>
            <title>Harry Potter and the Philospher Stone</title>
            <genre>Fantasy</genre>
            <boxofficeearnings>$974,755,371</boxofficeearnings>
            <year>2001</year>
        </movie>
        <movie>
            <title>Fantastic Beasts</title>
            <genre>Action</genre>
            <boxofficeearnings>$803,798,342</boxofficeearnings>
            <year>2016</year>
        </movie>
      </movies>
    XML

    before do
      inspector.add_data_type(
        type: "Movie",
        css_path: "movies movie",
        attributes: %i[year boxofficeearnings],
        identifier_attributes: %i[title],
      )
    end

    it "builds the expected objects" do
      expect(result.data_objects).to eq(
        [
          {
            type: "Movie",
            title: "Harry Potter and the Philospher Stone",
            year: "2001",
            boxofficeearnings: "$974,755,371",
          },
          {
            type: "Movie",
            title: "Fantastic Beasts",
            year: "2016",
            boxofficeearnings: "$803,798,342",
          },
        ],
      )
    end
  end
end
