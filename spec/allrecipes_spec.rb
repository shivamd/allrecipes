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
        expect(a_request(:get, "http://allrecipes.com/recipes?page=&st=p")).to have_been_made
      end
      it "count should be 20" do
        expect(@recipes.count).to eq 20
      end
    end
  end

  describe "#course" do

    context "without options" do

      before do
        VCR.use_cassette "course_1" do
          @recipes = subject.course("bread")
        end
      end

      it "requests the correct url" do
        expect(a_request(:get, "http://allrecipes.com/recipes/bread?page=&st=p")).to have_been_made
      end

      it "should return 20 recipes" do
        expect(@recipes.count).to eq 20
      end

    end

    context "non existent course" do
      let(:nonexistent_course) { -> { subject.course("nonexistent") } }
      it "should give appropriate error message" do
        expect(nonexistent_course).to raise_error("Course doesn't exist")
      end
    end

  end

  describe "#region" do
    context "without options main region" do
      before do
        VCR.use_cassette "region" do
          @recipes = subject.region("asian")
        end
      end

      it "requests the correct url" do
        expect(a_request(:get, "http://allrecipes.com/recipes/world-cuisine/asian?page=&st=p")).to have_been_made
      end

      it "should return 20 recipes" do
        expect(@recipes.count).to eq 20
      end

    end

    context "without options sub region" do

      before do
        VCR.use_cassette "sub_region" do
          @recipes = subject.region("chinese")
        end
      end

      it "requests the correct url" do
        expect(a_request(:get, "http://allrecipes.com/recipes/world-cuisine/asian/chinese?page=&st=p")).to have_been_made
      end

      it "should return 20 recipes" do
        expect(@recipes.count).to eq 20
      end

    end

    context "non existent region" do
      let(:nonexistent_region) { -> { subject.region("nonexistent") } }
      it "should give appropriate error message" do
        expect(nonexistent_region).to raise_error("Region doesn't exist")
      end
    end
  end

  describe "#ingredient" do
    context "without options" do
      before do
        VCR.use_cassette "ingredients" do
          @recipes = subject.ingredient("apples")
        end
      end

      it "requests the correct url" do
        expect(a_request(:get, "http://allrecipes.com/search/?wt=apples&page=&sb=re")).to have_been_made
      end

      it "should return 21 recipes" do
        expect(@recipes.count).to eq 21
      end

      it "should include a recipe with specified ingredient" do
        expect(@recipes.first[:ingredients].select{ |ingredient| ingredient[:name].include?("apples") }.count).to eq 1
      end

    end

    context "no recipes for ingredient" do
      let(:nonexistent_ingredient) { -> { subject.ingredient("nonexistent") } }
      it "should give appropriate error message" do
        expect(nonexistent_ingredient).to raise_error("Could not find recipes that include this ingredient")
      end
    end
  end

  describe "#recipe_url" do
    context "correct url" do
      before do
        VCR.use_cassette "recipe_url" do
          @recipe = subject.recipe_url("http://allrecipes.com/Recipe/Mushrooms-with-a-Soy-Sauce-Glaze")
        end
      end

      it "requests the correct url" do
        expect(a_request(:get, "http://allrecipes.com/Recipe/Mushrooms-with-a-Soy-Sauce-Glaze")).to have_been_made
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

    context "invalid url" do
      let(:invalid_allrecipes_url) { -> { subject.recipe_url("http://allrecipes.com") } }
      it "should give appropriate error message" do
        expect(invalid_allrecipes_url).to raise_error("This page does not contain a recipe")
      end

      let(:invalid_url) { -> { subject.recipe_url("invalid") } }
      it "should give appropriate error message" do
        expect(invalid_url).to raise_error("This page does not contain a recipe")
      end
    end

    context "with return keys" do
      before do
        VCR.use_cassette "recipe_url_with_keys" do
          @recipe = subject.recipe_url("http://allrecipes.com/Recipe/Mushrooms-with-a-Soy-Sauce-Glaze", ["name", "servings"])
        end
      end
      it "should return a formatted recipe" do
        expected_output = {
          name: @recipe[:name],
          servings: @recipe[:servings],
        }
        expect(@recipe).to eq expected_output
      end
    end

  end

  describe "#page_url" do
    context "correct url" do
      before do
        VCR.use_cassette "recipes_from_page" do
          @recipes = subject.page_url("http://allrecipes.com/recipes?st=n&Page=7")
        end
      end

      it "requests the correct URL" do
        expect(a_request(:get, "http://allrecipes.com/recipes?st=n&Page=7")).to have_been_made
      end

      it "should have the right count of recipes" do
        expect(@recipes.count).to eq 20
      end
    end
    context "invalid url" do
      let(:invalid_allrecipes_url) { -> { subject.page_url("http://allrecipes.com") } }
      it "should give appropriate error message" do
        expect(invalid_allrecipes_url).to raise_error("This page does not contain recipes")
      end

      let(:invalid_url) { -> { subject.page_url("invalid") } }
      it "should give appropriate error message" do
        expect(invalid_url).to raise_error("This page does not contain recipes")
      end
    end
    context "with return keys" do
      before do
        VCR.use_cassette "page_url_with_keys" do
          @recipes = subject.page_url("http://allrecipes.com/recipes?st=n&Page=7", ["name", "image"])
        end
      end
      it "should return a formatted recipe" do
        expected_output = {
          name: @recipes[0][:name],
          image: @recipes[0][:image],
        }
        expect(@recipes[0]).to eq expected_output
      end
    end
  end
end
