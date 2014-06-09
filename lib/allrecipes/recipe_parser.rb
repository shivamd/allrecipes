class RecipeParser
  $BASE_URL = "http://allrecipes.com"

  def initialize(page)
    @page = agent.get $BASE_URL + page
    @directions = []
    @ingredients = []
    get_ingredients
    get_directions
  end

  def agent
    Mechanize.new
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
    float_value = @page.search(rating_class).attr("content").inner_text.to_f
    (float_value * 2).round / 2.0 #to convert to nearest 0.5
  end

  def rating_class
    ".detail-right meta[itemprop='ratingValue']"
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

  def ingredients_list
    @page.search(ingredients_class)
  end

  def ingredients_class
    ".fl-ing"
  end

  def get_ingredients
    ingredients_list.each do |ingredient|
      amount = amount(ingredient)
      ingredient_name= ingredient_name(ingredient)
      add_ingredient_to_list(amount, ingredient_name)
    end
  end

  def add_ingredient_to_list(amount, ingredient_name)
    if amount && ingredient_name #some recipes have empty ingredients
      quantity,unit = amount.text.split(" ")
      @ingredients << { "quantity" => quantity.to_f, "unit"=>unit, "name" => ingredient_name.text }
    end
  end

  def amount(ingredient)
    ingredient.search(ingredient_amount_class).children[0]
  end

  def ingredient_amount_class
    ".ingredient-amount"
  end

  def ingredient_name(ingredient)
    ingredient.search(ingredient_name_class).children[0]
  end

  def ingredient_name_class
    ".ingredient-name"
  end

  def recipe
    {
      name: name,
      image: image,
      servings: servings,
      ingredients: @ingredients,
      directions: @directions,
      rating: rating
    }
  end

end
