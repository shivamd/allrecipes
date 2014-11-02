require 'spec_helper'
describe IngredientsParser do
  before do
    VCR.use_cassette "ingredients_parser" do
      url = "http://allrecipes.com/Recipe/Worlds-Best-Lasagna/"
      page = Mechanize.new.get(url)
      @ing_parser = IngredientsParser.new(page)
    end
  end

  it "should have the right amount of ingredients" do
    expect(@ing_parser.ingredients.count).to eq 21
  end

  it "should have the correct quantity" do
    expect(@ing_parser.ingredients.first[:quantity]).to eq 1
  end

  it "should have the correct quantity even if there is additional info" do
    expect(@ing_parser.ingredients[5][:quantity]).to eq 2
  end

  it "should have the correct unit" do
    expect(@ing_parser.ingredients.first[:unit]).to eq "pound"
  end

  it "should have the correct unit even if there is additional info" do
    expect(@ing_parser.ingredients[5][:unit]).to eq "cans"
  end

  it "should have the correct ingredient name" do
    expect(@ing_parser.ingredients.first[:name]).to eq "sweet Italian sausage"
  end
end
