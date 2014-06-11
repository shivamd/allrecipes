class RecipeParser

  def initialize(page)
    @page = request_page(page)
    @directions = []
    get_ingredients
    get_directions
  end

  def agent
    Mechanize.new
  end

  def request_page(page)
    if page.match(/allrecipes\.com/)
      agent.get page
    else
      raise "Invalid URL"
    end
  end

  def name
    @page.search(name_id).inner_text
  end

  def name_id
    "#itemTitle"
  end

  def image
    @page.search(image_id).first.attributes["src"].value
  end

  def image_id
    "#imgPhoto"
  end

  def servings
    @page.search(servings_id).inner_text.gsub(" servings", "").to_i
  end

  def servings_id
    "#lblYield"
  end

  def rating
    rating_html = @page.search(rating_class)
    if rating_html.length > 0
      float_value = rating_html.attr("content").inner_text.to_f
      (float_value * 2).round / 2.0 #to convert to nearest 0.5
    end
  end

  def rating_class
    ".detail-right meta[itemprop='ratingValue']"
  end

  def time(type)
    minutes = minutes(type)
    hours = hours(type)
    time = 0
    time += minutes ? minutes.inner_text.to_i : 0
    time += hours ? hours.inner_text.to_i * 60 : 0 #hours to minutes
  end

  def minutes(type)
    @page.search("##{type}MinsSpan em")
  end

  def hours(type)
    @page.search("##{type}HoursSpan em")
  end

  def preparation_time
    time("prep")
  end

  def cooking_time
    time("cook")
  end

  def directions_class
    ".directions ol li span"
  end

  def directions_list
    @page.search(directions_class)
  end

  def get_directions
    directions_list.each do |direction|
      @directions << direction.text
    end
  end

  def get_ingredients
    @ingredients = IngredientsParser.new(@page).ingredients
  end

  def recipe
    begin
      {
        name: name,
        image: image,
        servings: servings,
        ingredients: @ingredients,
        directions: @directions,
        rating: rating,
        prep_time: preparation_time,
        cook_time: cooking_time
      }
    rescue
      raise "Error getting recipe"
    end
  end

end
