require 'spec_helper'
describe RecipeParser do
  before do
    VCR.use_cassette "recipe" do
      url = "http://allrecipes.com/Recipe/Worlds-Best-Lasagna/"
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

  it "should have the right rating" do
    expect(@recipe[:rating]).to eq 5
  end

  it "should have the right prep time" do
    expect(@recipe[:prep_time]).to eq 30
  end

  it "should have the right cook time" do
    expect(@recipe[:cook_time]).to eq 150
  end

  it "should have the right amount of ingredients" do
    expect(@recipe[:ingredients].count).to eq 21
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
      directions: @recipe[:directions],
      rating: @recipe[:rating],
      prep_time: @recipe[:prep_time],
      cook_time: @recipe[:cook_time]
    }
    expect(@recipe).to eq expected_output
  end
end
