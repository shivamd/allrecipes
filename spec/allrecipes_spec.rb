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
end
