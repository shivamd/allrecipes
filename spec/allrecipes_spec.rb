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

end
