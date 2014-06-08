class Allrecipes
  $URL= "http://allrecipes.com"
  include URLHelper

  def initialize
    @agent = Mechanize.new
  end

  def all(options={})
    page = @agent.get $URL + "/recipes"
    PageParser.new(page).recipes
  end

  def course(course_type, options={})
    begin
      course_url = get_course_url(course_type)
      page = @agent.get(course_url)
      PageParser.new(page).recipes
    rescue Exception
      raise "Course type doesn't exist"
    end
  end


end

