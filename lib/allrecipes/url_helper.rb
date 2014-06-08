module URLHelper

  def get_course_url(course_type)
    begin
      "http://allrecipes.com/recipes/" + courses[course_type]
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
    end
  end

  def courses
    #course type and matching URL based on allrecipes.com
    {
      "bread"=> "bread",
      "appetizer"=> "appetizers-and-snacks",
      "breakfast"=> "breakfast-and-brunch",
      "dessert"=> "desserts",
      "drink"=> "drinks",
      "main"=> "main-dish",
      "salad"=> "salad",
      "side"=> "side-dish",
      "soup"=> "soups-stews-and-chili",
      "fruit"=> "fruits-and-vegetables",
      "herbs"=> "herbs-and-spices",
      "meat"=> "meat-and-poultry",
      "pasta"=> "pasta",
      "seafood"=> "seafood",
      "wholegrains"=> "whole-grains"
    }
  end
end
