class PageParser

  def initialize(page, options={})
    @page = page
    @recipes = []
    @options = options
    get_recipes
  end

  def recipe_info_class
     ".recipe-info"
  end

  def title_class
    ".title"
  end

  def recipe_info
     if @options[:type] == "ingredient"
       @page.search(recipe_info_class)
     else
       recipes_grid.search(recipe_info_class)
     end
  end

  def recipes_grid_class
    ".grid-view"
  end

  def recipes_grid
    @page.search(recipes_grid_class)[-1]
  end

  def recipe_link(info)
    info.search(title_class)[0].attributes["href"].value
  end

  def get_recipes
    recipe_info.each do |info|
      recipe_link = recipe_link(info)
      @recipes <<  RecipeParser.new(recipe_link).recipe
    end
  end

  def recipes
    @recipes
  end

end
