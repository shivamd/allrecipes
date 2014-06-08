# Allrecipes

A Ruby interface to a Allrecipes.com scraper.

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
2. Ability to search by course.
3. Ability to search by region
4. Increase test coverage.
