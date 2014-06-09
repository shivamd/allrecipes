# Allrecipes

A Ruby interface to the Allrecipes API.
Allrecipes doesn't have an API, the requests are done using mechanize.

## Installation

Add this line to your application's Gemfile:

    gem 'allrecipes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install allrecipes

## Usage

**Initialize scraper**
```ruby
recipes = Allrecipes.new
```

**Get all recipes**
```ruby
recipes.all #default sorted by popularity, limit 20.
```

**Get recipes by course**
```ruby
recipes.course("breakfast") #default sorted by popularity, limit 20.
```
List of courses: 
```ruby
[ "appetizer", "bread", "breakfast", "dessert", "drink","fruit", "herbs", "main", "salad", "soup", "meat", "pasta", "seafood", "wholegrains"]
```

**Get recipes by region**
```ruby
recipes.region("european") #default sorted by popularity, limit 20.
```

Specific options available
```ruby
recipes.region("french") #default sorted by popularity, limit 20.
```

List of regions available: 
```ruby
[
  "asian"
    "chinese" 
    "thai" 
    "japanese" 
    "filipino" 
    "korean" 
    "vietnamese" 
    "malaysian" 
    "pakistani" 
    "indonesian" 
    "iranian" 
    "bangladeshi" 
    "indian" 

  "african"
    "african_main"
    "moroccan"
    "south_african"
    "egyptian"

  "australian"

  "canadian"
    "vancouver" 
    "toronto" 
    "quebec" 

  "european"
    "italian"
    "uk"
    "french"
    "greek"
    "eastern_european"
    "german"
    "scandinavian"
    "spanish"
    "portuguese"
    "dutch"
    "austrian"
    "swiss"
    "belgian"

  "latin_american"
    "mexican" 
    "caribbean" 
    "south_american" 

  "middle_eastern"
    "lebanese" 
    "turkish" 
    "israeli" 
]
```

**Get recipes by ingredient**
```ruby
recipes.ingredient("apples") #default sorted by relevance, limit 21.
```

**Sample response**
```ruby
[
    {
      :name => "Lasagna",
      :image => "http://images.media-allrecipes.com/userphotos/250x250/00/03/24/32427.jpg",
      :servings => 12,
      :ingredients =>
        [
          {
            "quantity" => 1.0,
            "unit" => "pound", 
            "name" => "ground beef"
          }
        ],
     :directions => 
       [
         {
           "Bring a large pot of lightly salted water to a boil"
         }
       ]
    }
]
```

## Todo

1. Filters on search (offset, limit & sort_by)
2. Complex search with queries such as multiple ingredients, course, time etc.
3. Add prep time & cook time to results
4. Add nutrional info to results.
5. Add rating to results
6. Add user photos for recipe to results
7. Able to get popular recipes of the day.
8. Able to insert recipe URL directly. 
9. Able to add page URL directly.
