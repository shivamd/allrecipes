class Allrecipes
  $URL= "http://allrecipes.com"

  def initialize
    @agent = Mechanize.new
  end

  def all(options={})
    page = @agent.get $URL + "/recipes"
    PageParser.new(page).recipes
  end
end
