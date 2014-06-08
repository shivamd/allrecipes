require 'spec_helper'
describe Allrecipes do
  subject { Allrecipes.new }

  describe "#all" do
    context "without options" do
      before do
        VCR.use_cassette "all" do
          @recipes = subject.all
        end
      end
      it "requests the correct url" do
        expect(a_request(:get, "http://allrecipes.com/recipes")).to have_been_made
      end
      it "count should be 20" do
        expect(@recipes.count).to eq 20
      end
    end
  end

end
