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
          expect(a_request(:get, "http://allrecipes.com/recipes?page=2&st=p")).to have_been_made
          expect(a_request(:get, "http://allrecipes.com/recipes/world-cuisine/asian?page=3&st=p")).to have_been_made
          expect(a_request(:get, "http://allrecipes.com/recipes/bread?page=4&st=p")).to have_been_made
          expect(a_request(:get, "http://allrecipes.com/search/?wt=apples&page=5&sb=re")).to have_been_made
        end

        it "should be different from the initial page" do
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
          expect(a_request(:get, "http://allrecipes.com/recipes?page=10000&st=p")).to have_been_made
          expect(a_request(:get, "http://allrecipes.com/recipes/world-cuisine/asian?page=10000&st=p")).to have_been_made
          expect(a_request(:get, "http://allrecipes.com/recipes/bread?page=10000&st=p")).to have_been_made
          expect(a_request(:get, "http://allrecipes.com/search/?wt=apples&page=10000&sb=re")).to have_been_made
        end

        it "should return an empty array" do
          expect(@all_recipes).to eq []
          expect(@region_recipes).to eq []
          expect(@course_recipes).to eq []
          expect(@ingredient_recipes).to eq []
        end
      end
    end

    context "sort by" do
      describe "valid sort" do
        before do
          VCR.use_cassette "default search" do
              @all_recipes_initial = subject.all
              @region_recipes_initial = subject.region("asian")
              @course_recipes_initial = subject.course("bread")
              @ingredient_recipes_initial = subject.ingredient("apples")
          end
        end
        context "popularity" do
          before do
            VCR.use_cassette "popularity_sort" do
              @all_recipes = subject.all({ sort_by: "popularity" })

              @region_recipes = subject.region("asian", { sort_by: "popularity"})
              @course_recipes = subject.course("bread", { sort_by: "popularity"})
              @ingredient_recipes = subject.ingredient("apples", { sort_by: "popularity"})
            end
          end

          it "should call the correct URLs" do
            expect(a_request(:get, "http://allrecipes.com/recipes?page=&st=p")).to have_been_made.times(2)
            expect(a_request(:get, "http://allrecipes.com/recipes/world-cuisine/asian?page=&st=p")).to have_been_made.times(2)
            expect(a_request(:get, "http://allrecipes.com/recipes/bread?page=&st=p")).to have_been_made.times(2)
            expect(a_request(:get, "http://allrecipes.com/search/?wt=apples&page=&sb=re")).to have_been_made

          end

          it "should have the correct count of recipes" do
            expect(@all_recipes.count).to eq 20
            expect(@region_recipes.count).to eq 20
            expect(@course_recipes.count).to eq 20
            expect(@ingredient_recipes.count).to eq 21
          end

          it "should have default search sorted bsorted by popularity" do
            expect(@all_recipes).to eq @all_recipes_initial
            expect(@region_recipes).to eq @region_recipes_initial
            expect(@course_recipes).to eq @course_recipes_initial
          end

          it "should search for recipes based on ingredients sorted by popularity" do
            expect(@ingredient_recipes).to_not eq @ingredient_recipes_initial
          end
        end

        context "date" do
          before do
            VCR.use_cassette "date_sort" do
              @all_recipes = subject.all({ sort_by: "date" })

              @region_recipes = subject.region("asian", { sort_by: "date"})
              @course_recipes = subject.course("bread", { sort_by: "date"})
            end
          end

          it "should call the correct URLs" do
            expect(a_request(:get, "http://allrecipes.com/recipes?page=&st=n")).to have_been_made
            expect(a_request(:get, "http://allrecipes.com/recipes/world-cuisine/asian?page=&st=n")).to have_been_made
            expect(a_request(:get, "http://allrecipes.com/recipes/bread?page=&st=n")).to have_been_made
          end

          it "should have the correct count of recipes" do
            expect(@all_recipes.count).to eq 20
            expect(@region_recipes.count).to eq 20
            expect(@course_recipes.count).to eq 20
          end

          it "should be different than default search" do
            expect(@all_recipes).to_not eq @all_recipes_initial
            expect(@region_recipes).to_not eq @region_recipes_initial
            expect(@course_recipes).to_not eq @course_recipes_initial
          end
        end
        context "title" do
          before do
            VCR.use_cassette "title_sort" do
              @all_recipes = subject.all({ sort_by: "title" })

              @region_recipes = subject.region("asian", { sort_by: "title"})
              @course_recipes = subject.course("bread", { sort_by: "title"})
            end
          end

          it "should call the correct URLs" do
            expect(a_request(:get, "http://allrecipes.com/recipes?page=&st=t")).to have_been_made
            expect(a_request(:get, "http://allrecipes.com/recipes/world-cuisine/asian?page=&st=t")).to have_been_made
            expect(a_request(:get, "http://allrecipes.com/recipes/bread?page=&st=t")).to have_been_made
          end

          it "should have the correct count of recipes" do
            expect(@all_recipes.count).to eq 20
            expect(@region_recipes.count).to eq 20
            expect(@course_recipes.count).to eq 20
          end

          it "should be different than default search" do
            expect(@all_recipes).to_not eq @all_recipes_initial
            expect(@region_recipes).to_not eq @region_recipes_initial
            expect(@course_recipes).to_not eq @course_recipes_initial
          end
        end
        context "Relevance for ingredient search" do
          before do
            VCR.use_cassette "relevance_sort" do
              @ingredient_recipes = subject.ingredient("apples",{ sort_by: "relevance" })
            end
          end

          it "should call the correct URL" do
            expect(a_request(:get, "http://allrecipes.com/search/?wt=apples&page=&sb=re")).to have_been_made.times(2)
          end

          it "should have the correct count of recipes" do
            expect(@ingredient_recipes.count).to eq 21
          end

          it "should be the same as default search" do
            recipe_names = @ingredient_recipes.map{ |ing| ing[:name] }.sort
            initial_recipe_names = @ingredient_recipes_initial.map{ |ing| ing[:name] }.sort
            expect(recipe_names).to eq initial_recipe_names
          end
        end
        context "Rating sort for ingredient search" do
          before do
            VCR.use_cassette "rating_sort" do
              @ingredient_recipes = subject.ingredient("apples",{ sort_by: "rating" })
            end
          end

          it "should call the correct URL" do
            expect(a_request(:get, "http://allrecipes.com/search/?wt=apples&page=&sb=ra")).to have_been_made
          end

          it "should have the correct count of recipes" do
            expect(@ingredient_recipes.count).to eq 21
          end

          it "should be different from default search" do
            expect(@ingredient_recipes).to_not eq @ingredient_recipes_initial
          end
        end
      end
    end
  end
end
