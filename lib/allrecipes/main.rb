class Allrecipes
  $URL= "http://allrecipes.com"
  include URLHelper

  def initialize
    @agent = Mechanize.new
  end

  def all(options={})
    page = @agent.get $URL + "/recipes" + recipe_filters(options)
    PageParser.new(page, options).recipes
  end

  def course(course_type, options={})
    recipe_search(course_type, options.merge({ url_type: "course" }))
  end

  def region(region_type, options={})
    recipe_search(region_type, options.merge({ url_type: "region" }))
  end

  def recipe_search(type, options)
    begin
      url = recipes_url(type, options)
      page = @agent.get(url)
      PageParser.new(page, options).recipes
    rescue Exception
      raise "#{options[:url_type].capitalize} doesn't exist"
    end
  end

  def ingredient(name, options={})
    begin
      url = $URL + "/search/?wt=#{name}&page=#{options[:page]}&sb=#{ingredient_sort_parameter(options[:sort_by])}"
      page = @agent.get(url)
      options = options.merge({type: "ingredient"})
      PageParser.new(page, options).recipes
    rescue Exception
      raise "Could not find recipes that include this ingredient"
    end
  end

  def recipe_url(url)
    begin
      RecipeParser.new(url).recipe
    rescue Exception
      raise "This page does not contain a recipe"
    end
  end

  def page_url(url)
    begin
      page = @agent.get(url)
      PageParser.new(page).recipes
    rescue Exception
      raise "This page does not contain recipes"
    end
  end
end

