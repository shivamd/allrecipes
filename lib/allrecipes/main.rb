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
    begin
      course_url = recipes_url(course_type, options.merge({ url_type: "course" }))
      page = @agent.get(course_url)
      PageParser.new(page, options).recipes
    rescue Exception
      raise "Course type doesn't exist"
    end
  end

  def region(region_type, options={})
    begin
      region_url = recipes_url(region_type, options.merge({ url_type: "region" }))
      page = @agent.get(region_url)
      PageParser.new(page, options).recipes
    rescue Exception
      raise "Region doesn't exist"
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
end

