require 'spec_helper'
describe PageParser do
  before do
    VCR.use_cassette "page" do
      url = "http://allrecipes.com/recipes"
      page = Mechanize.new.get(url)
      @parser = PageParser.new(page)
    end
  end

  it "should have the right amount of recipes" do
    expect(@parser.recipes.count).to eq 20
  end

end
