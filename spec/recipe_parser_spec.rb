require 'spec_helper'
describe RecipeParser do
  before do
    VCR.use_cassette "recipe" do
      url = "/Recipe/Worlds-Best-Lasagna/"
      @recipe = RecipeParser.new(url).recipe
    end
  end

  it "should have the right name" do
    expect(@recipe[:name]).to eq "World's Best Lasagna"
  end

  it "should have the right image url" do
    expect(@recipe[:image]).to eq "http://images.media-allrecipes.com/userphotos/250x250/00/03/24/32427.jpg"
  end

  it "should have the right amount of servings" do
    expect(@recipe[:servings]).to eq 12
  end

  context "ingredients" do

    it "should have the right amount of ingredients" do
      expect(@recipe[:ingredients].count).to eq 21
    end
    it "should have the right quantity" do
      expect(@recipe[:ingredients].first["quantity"]).to eq 1
    end
    it "should have the right unit" do
      expect(@recipe[:ingredients].first["unit"]).to eq "pound"
    end
    it "should have the right name" do
      expect(@recipe[:ingredients].first["name"]).to eq "sweet Italian sausage"
    end

  end

  it "should have the right amount of directions" do
    expect(@recipe[:directions].count).to eq 5
  end

  it "should return a formatted recipe" do
    expected_output = {
      name: @recipe[:name],
      image: @recipe[:image],
      servings: @recipe[:servings],
      ingredients: @recipe[:ingredients],
      directions: @recipe[:directions]
    }
    expect(@recipe).to eq expected_output
  end
end
