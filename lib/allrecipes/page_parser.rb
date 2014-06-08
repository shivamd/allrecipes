class PageParser

  def initialize(page)
    @page = page
    @recipes = []
    get_recipes
  end

  def recipe_info_class
     ".recipe-info"
  end

  def title_class
    ".title"
  end

  def recipe_info
     recipes_grid.search(recipe_info_class)
  end

  def recipes_grid_class
    ".grid-view"
  end

  def recipes_grid
    @page.search(recipes_grid_class)[1]
  end

  def get_recipes
    recipe_info.each do |info|
      recipe_link = info.search(title_class)[0].attributes["href"].value
      @recipes <<  RecipeParser.new(recipe_link).recipe
    end
  end

  def recipes
    @recipes
  end

end
