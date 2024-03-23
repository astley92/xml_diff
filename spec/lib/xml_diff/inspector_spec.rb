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

    context "with no data types defined" do
      it "does not build any objects" do
        expect(result.data_objects).to eq([])
      end
    end

    context "when the data types are found" do
      let(:attributes) { %i[title year boxofficeearnings] }
      let(:identifier_attributes) { %i[title] }

      before do
        inspector.add_data_type(
          type: "Movie",
          document_path: "movies movie",
          attributes:,
          identifier_attributes:,
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

      context "when there are multiple matches for an identifier attribute" do
        let(:xml) { <<~XML }
          <movies>
            <movie>
              <title>Harry Potter and the Philospher Stone</title>
              <title>Harry Potter and the Order of the Pheonix</title>
            </movie>
          </movies>
        XML

        it "raises the expected error" do
          expect { result }.to raise_error(
            XmlDiff::Inspector::AmbiguousIdentifierAttributeError,
            "Movie data type was found, but identifier attribute `title` was not unique.",
          )
        end
      end

      context "when some of the attributes are not in the xml" do
        let(:attributes) { %i[year boxofficeearnings rating] }

        it "builds the objects with the available attributes" do
          expect(result.data_objects).to eq(
            [
              {
                type: "Movie",
                title: "Harry Potter and the Philospher Stone",
                year: "2001",
                boxofficeearnings: "$974,755,371",
                rating: nil,
              },
              {
                type: "Movie",
                title: "Fantastic Beasts",
                year: "2016",
                boxofficeearnings: "$803,798,342",
                rating: nil,
              },
            ],
          )
        end
      end

      context "when the identifier attributes are not in the xml" do
        let(:attributes) { %i[title year boxofficeearnings] }
        let(:identifier_attributes) { %i[title rating] }

        it "raises the expected error" do
          expect { result }.to raise_error(
            XmlDiff::Inspector::MissingIdentifierAttributeError,
            "Movie data type was found, but identifier attribute `rating` was not present.",
          )
        end
      end
    end

    context "when the data type is not found" do
      before do
        inspector.add_data_type(
          type: "Actor",
          document_path: "actors actor",
          attributes: %i[name],
          identifier_attributes: %i[name],
        )
      end

      it "simply returns no results" do
        expect(result.data_objects).to eq([])
      end
    end
  end
end
