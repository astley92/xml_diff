# frozen_string_literal: true

RSpec.describe XmlDiff::Diff::Generator do
  describe ".run" do
    subject(:result) { described_class.run(inspector, data_one, data_two) }

    let(:inspector) { XmlDiff::Inspector.new }
    let(:data_one) { <<~XML }
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
        document_path: "movies movie",
        attributes: %i[title year boxofficeearnings],
        identifier_attributes: %i[title],
      )
    end

    context "when the data is the same" do
      let(:data_two) { data_one }

      it "returns no changes" do
        expect(result.additions).to eq([])
        expect(result.deletions).to eq([])
        expect(result.changes).to eq([])
      end
    end

    context "when the data contains removals" do
      let(:data_two) { <<~XML }
        <movies>
          <movie>
              <title>Harry Potter and the Philospher Stone</title>
              <genre>Fantasy</genre>
              <boxofficeearnings>$974,755,371</boxofficeearnings>
              <year>2001</year>
          </movie>
        </movies>
      XML

      it "returns the removals" do
        expect(result.additions.count).to eq(0)
        expect(result.deletions.count).to eq(1)
        expect(result.changes.count).to eq(0)
      end
    end

    context "when the data contains additions" do
      let(:data_two) { <<~XML }
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
          <movie>
              <title>Harry Potter and the Chamber of Secrets</title>
              <genre>Fantasy</genre>
              <boxofficeearnings>$879,465,646</boxofficeearnings>
              <year>2002</year>
          </movie>
        </movies>
      XML

      it "returns the additions" do
        expect(result.additions.count).to eq(1)
        expect(result.deletions.count).to eq(0)
        expect(result.changes.count).to eq(0)
      end
    end

    context "when the data contains changes" do
      let(:data_two) { <<~XML } # Fantastic Beasts year changed to 2015
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
              <year>2015</year>
          </movie>
        </movies>
      XML

      it "returns the changes" do
        expect(result.additions.count).to eq(0)
        expect(result.deletions.count).to eq(0)
        expect(result.changes.count).to eq(1)
      end
    end
  end
end
