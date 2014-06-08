require 'spec_helper'
describe Allrecipes do
  subject { Allrecipes.new }
  describe "options" do
    context "limit" do
      describe "valid limit" do
        before do
          VCR.use_cassette "valid_limit" do
            @all_recipes = subject.all({limit: 10})
            @region_recipes = subject.region("asian", {limit: 10})
            @course_recipes = subject.course("bread", {limit: 10})
            @ingredient_recipes = subject.ingredient("apples", {limit: 10})
          end
        end

        it "should restrict recipes to 10" do
          expect(@all_recipes.count).to eq 10
          expect(@region_recipes.count).to eq 10
          expect(@course_recipes.count).to eq 10
          expect(@ingredient_recipes.count).to eq 10
        end
      end
    end

    context "page" do
      describe "valid page" do
        before do
          VCR.use_cassette "valid_pages" do
            @all_recipes = subject.all({page: 2})
            @all_recipes_initial = subject.all

            @region_recipes = subject.region("asian", {page: 3})
            @region_recipes_initial = subject.region("asian")

            @course_recipes = subject.course("bread", {page: 4})
            @course_recipes_initial = subject.course("bread")

            @ingredient_recipes = subject.ingredient("apples", {page: 5})
            @ingredient_recipes_intiial = subject.ingredient("apples")
          end
        end

        it "should call the correct urls" do
          expect(a_request(:get, "http://allrecipes.com/recipes?page=2")).to have_been_made
          expect(a_request(:get, "http://allrecipes.com/recipes/world-cuisine/asian?page=3")).to have_been_made
          expect(a_request(:get, "http://allrecipes.com/recipes/bread?page=4")).to have_been_made
          expect(a_request(:get, "http://allrecipes.com/search/?wt=apples&page=5")).to have_been_made
        end

        its "results should be different from the initial page" do
          expect(@all_recipes).to_not eq @all_recipes_initial
          expect(@region_recipes).to_not eq @region_recipes_initial
          expect(@course_recipes).to_not eq @course_recipes_initial
          expect(@ingredient_recipes).to_not eq @ingredient_recipes_initial
        end
      end

      describe "invalid page" do
        before do
          VCR.use_cassette "invalid page" do
            @all_recipes = subject.all({ page: 10000 })
            @region_recipes = subject.region("asian", { page: 10000 })
            @course_recipes = subject.course("bread", { page: 10000 })
            @ingredient_recipes = subject.ingredient("apples", { page: 10000 })
          end
        end

        it "should call correct url" do
          expect(a_request(:get, "http://allrecipes.com/recipes?page=10000")).to have_been_made
          expect(a_request(:get, "http://allrecipes.com/recipes/world-cuisine/asian?page=10000")).to have_been_made
          expect(a_request(:get, "http://allrecipes.com/recipes/bread?page=10000")).to have_been_made
          expect(a_request(:get, "http://allrecipes.com/search/?wt=apples&page=10000")).to have_been_made
        end

        it "should return an empty array" do
          expect(@all_recipes).to eq []
          expect(@region_recipes).to eq []
          expect(@course_recipes).to eq []
          expect(@ingredient_recipes).to eq []
        end
      end
    end
  end
end
