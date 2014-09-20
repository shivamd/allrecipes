class IngredientsParser
  def initialize(page)
    @page = page
    @ingredients = []
    parse_ingredients
  end

  def parse_ingredients
    ingredients_list.each do |ingredient|
      amount = amount(ingredient)
      ingredient_name= ingredient_name(ingredient)
      add_ingredient_to_list(amount, ingredient_name)
    end
  end

  def ingredients_list
    @page.search(ingredients_class)
  end

  def ingredients_class
    ".fl-ing"
  end

  def add_ingredient_to_list(amount, ingredient_name)
    if amount && ingredient_name #some recipes have empty ingredients
      _details = amount.text.split(" ")
      quantity = eval "#{_details[0]}.0"
      unit = _details.last
      @ingredients << { quantity: quantity.to_f, unit: unit, name: ingredient_name.text }
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

  def ingredients
    @ingredients
  end
end
