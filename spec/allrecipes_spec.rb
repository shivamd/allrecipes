require 'spec_helper'
describe Allrecipes do
  subject { Allrecipes.new }

  describe "#all" do
    before do
      stub_request(:get, "http://allrecipes.com/recipes").to_return(body: fixture('recipe.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    context "without options" do
      before do
        @recipes = subject.all
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
