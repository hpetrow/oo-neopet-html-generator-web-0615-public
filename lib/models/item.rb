require 'pry'

class Item
  # attrs here
  attr_reader :type

  # initialize here

  def initialize
    @type = get_type
  end

  # other methods here

  def get_type
    items = Dir["public/img/items/*"]
    type = items[rand(1...items.count)]
    type.gsub("public/img/items/", "").gsub(".jpg", "")
  end

  def format_type
    @type.split("_").collect {|word|
      word.capitalize
    }.join(" ")
  end
end
