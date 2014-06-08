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

  describe "#course" do

    context "without options" do

      before do
        VCR.use_cassette "course_1" do
          @recipes = subject.course("bread")
        end
      end

      it "requests the correct url" do
        expect(a_request(:get, "http://allrecipes.com/recipes/bread"))
      end

      it "should return 20 recipes" do
        expect(@recipes.count).to eq 20
      end

    end

    context "non existent course" do
      let(:nonexistent_course) { -> { subject.course("nonexistent") } }
      it "should give appropriate error message" do
        expect(nonexistent_course).to raise_error("Course type doesn't exist")
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
        expect(a_request(:get, "http://allrecipes.com/recipes/world-cuisine/asian"))
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
        expect(a_request(:get, "http://allrecipes.com/recipes/world-cuisine/asian/chinese"))
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
        expect(a_request(:get, "http://allrecipes.com/search/?wt=apples"))
      end

      it "should return 21 recipes" do
        expect(@recipes.count).to eq 21
      end

      its "recipes should include apple" do
        expect(@recipes.first[:ingredients].select{ |ingredient| ingredient["name"].include?("apples") }.count).to eq 1
      end

    end

    context "no recipes for ingredient" do
      let(:nonexistent_ingredient) { -> { subject.ingredient("nonexistent") } }
      it "should give appropriate error message" do
        expect(nonexistent_ingredient).to raise_error("Could not find recipes that include this ingredient")
      end
    end
  end

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
