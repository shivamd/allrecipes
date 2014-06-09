module URLHelper
  COURSES = {
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

  REGIONS = {
              "asian"=> "asian",
                "chinese" => "asian/chinese",
                "thai" => "asian/thai",
                "japanese" => "asian/japanese",
                "filipino" => "asian/filipino",
                "korean" => "asian/korean",
                "vietnamese" => "asian/vietnamese",
                "malaysian" => "asian/malaysian",
                "pakistani" => "asian/pakistani",
                "indonesian" => "asian/indonesian",
                "iranian" => "asian/iranian",
                "bangladeshi" => "asian/bangladeshi",
                "indian" => "asian/indian",

              "african"=> "african",
                "african_main"=> "african/main-dishes",
                "moroccan"=> "african/moroccan",
                "south_african"=> "african/south-african",
                "egyptian"=> "african/egyptian",

              "australian"=> "australian-and-new-zealander",

              "canadian"=> "canadian",
                "vancouver" => "canadian/vancouver",
                "toronto" => "canadian/toronto",
                "quebec" => "canadian/quebec-recipes",

              "european"=> "european",
                "italian"=> "european/italian",
                "uk"=> "european/uk-and-ireland",
                "french"=> "european/french",
                "greek"=> "european/greek",
                "eastern_european"=> "european/eastern-european",
                "german"=> "european/german",
                "scandinavian"=> "european/scandinavian",
                "spanish"=> "european/spanish",
                "portuguese"=> "european/portuguese",
                "dutch"=> "european/dutch",
                "austrian"=> "european/austrian",
                "swiss"=> "european/swiss",
                "belgian"=> "european/belgian",

              "latin_american"=> "latin-american",
                "mexican" => "latin-american/mexican",
                "caribbean" => "latin-american/caribbean",
                "south_american" => "latin-american/south-american",

              "middle_eastern"=> "middle-eastern",
                "lebanese" => "middle-eastern/lebanese",
                "turkish" => "middle-eastern/turkish",
                "israeli" => "middle-eastern/israeli",

            }

  def course_base_url(course_type)
    "http://allrecipes.com/recipes/" + COURSES[course_type]
  end

  def region_base_url(region_type)
    "http://allrecipes.com/recipes/world-cuisine/" + REGIONS[region_type]
  end

  def recipes_url(type, options)
    base = send("#{options[:url_type]}_base_url", type)
    filters = recipe_filters(options)
    [base, filters].join
  end

  def recipe_filters(options)
    "?page=#{options[:page]}&st=#{search_sort_parameter(options[:sort_by])}"
  end

  def search_sort_parameter(sort_type)
    case sort_type
      when "date" then "n"
      when "title" then "t"
      else "p"
    end
  end

  def ingredient_sort_parameter(sort_type)
    case sort_type
      when "rating" then "ra"
      when "popularity" then "p"
      else "re"
    end
  end
end
