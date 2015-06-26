require 'pry'

class User
  # attrs here
  attr_reader :name, :items, :neopets
  attr_accessor :neopoints

  PET_NAMES = ["Angel", "Baby", "Bailey", "Bandit", "Bella", "Buddy", "Charlie", "Chloe", "Coco", "Daisy", "Lily", "Lucy", "Maggie", "Max", "Molly", "Oliver", "Rocky", "Shadow", "Sophie", "Sunny", "Tiger"]

  # initialize here

  def initialize(name)
    @name = name
    @neopoints = 2500
    @items = []
    @neopets = []
  end

  # other methods here
  def select_pet_name
    unique_names = PET_NAMES.select {|name|
      !@neopets.collect {|neopet| neopet.name}.include?(name)
    }.first
  end

  def make_file_name_for_index_page
    self.name.downcase.gsub(" ", "-")
  end

  def buy_item
    if self.neopoints >= 150
      item = Item.new
      self.items << item
      self.neopoints -= 150
      "You have purchased a #{item.type}."
    else
      "Sorry, you do not have enough Neopoints."
    end
  end

  def buy_neopet
    if self.neopoints >= 250
      neopet = Neopet.new(select_pet_name)
      self.neopets << neopet
      self.neopoints -= 250
      "You have purchased a #{neopet.species} named #{neopet.name}."
    else
      "Sorry, you do not have enough Neopoints."
    end
  end

  def find_item_by_type(type)
    self.items.select{|item| item.type == type}.first
  end

  def find_neopet_by_name(name)
    self.neopets.select{|neopet| neopet.name == name}.first
  end

  def sell_neopet_by_name(name)
    neopet = self.find_neopet_by_name(name)
    if (neopet != nil)
      self.neopoints += 200
      self.neopets.delete(self.find_neopet_by_name(name))
      "You have sold #{name}. You now have #{self.neopoints} neopoints."
    else
      "Sorry, there are no pets named #{name}."
    end
  end

  def feed_neopet_by_name(name)
    neopet = self.find_neopet_by_name(name)
    if (neopet.happiness == 10)
      "Sorry, feeding was unsuccessful as #{neopet.name} is already ecstatic."
    else
      if neopet.happiness < 9
        neopet.happiness += 2
      elsif neopet.happiness == 9
        neopet.happiness += 1
      end
      "After feeding, #{neopet.name} is #{neopet.mood}."
    end
  end

  def give_present(present, neopet)
    item = self.find_item_by_type(present)
    neopet = self.find_neopet_by_name(neopet)
    if (item != nil && neopet != nil)
      self.items.delete(item)
      neopet.items << item
      if (neopet.happiness <= 5)
        neopet.happiness += 5
      else
        neopet.happiness = 10
      end
      "You have given a #{item.type} to #{neopet.name}, who is now #{neopet.mood}."
    else
      "Sorry, an error occurred. Please double check the item type and neopet name."
    end
  end

  def make_index_page
    file = File.new("views/users/#{self.make_file_name_for_index_page}.html", "w+")
    file.puts "<!DOCTYPE html>"
    file.puts "</body></html>"
    file.puts "<html><head>"
    file.puts "<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css\">"
    file.puts "<link rel=\"stylesheet\" href=\"http://getbootstrap.com/examples/jumbotron-narrow/jumbotron-narrow.css\">"
    file.puts "<title>#{self.name}</title>"
    file.puts "</head><body>"
    file.puts "<div class='container'>"
    file.puts "<div class='jumbotron'>"
    file.puts "<h1>#{self.name}</h1>"
    file.puts "<h3><strong>Neopoints:</strong> #{self.neopoints}</h3>"
    file.puts "</div>" # end jumbotron
    file.puts "<div class='row marketing'>"

    file.puts "<div class='col-lg-6'>"
    file.puts "<h3>Neopets</h3>"
    file.puts "<ul>"
    self.neopets.each {|neopet|
      file.puts "<li><img src=\"../../public/img/neopets/#{neopet.species}.jpg\"></li>"
      file.puts "<ul>"
      ["name", "mood", "species", "strength", "defence", "movement"].each { |method|
        file.puts "<li><strong>#{method.capitalize}:</strong> #{neopet.send(method)}</li>"
      }
      file.puts "<ul>"
        neopet.items.each { |item|
          file.puts "<li><img src='../../public/img/items/#{item.type}.jpg'></li>"
          file.puts "<ul><li><strong>Type:</strong> #{item.type}</li></ul>"
        }
      file.puts "</ul>"
      file.puts "</ul>"
    }
    file.puts "</ul>"
    file.puts "</div>"  # end listing neopets

    file.puts "<div class='col-lg-6'>"
    file.puts "<h3>Items</h3>"
    file.puts "<ul>"
    self.items.each { |item|
      file.puts "<li><img src=\"../../public/img/items/#{item.type}.jpg\"></li>"
      file.puts "<ul><li><strong>Type:</strong> #{item.format_type}</li></ul>"

    }
    file.puts "</ul>"
    file.puts "</div>"

    file.puts "</div>" # end row marketing
    file.puts "</div>" # end containter
    file.puts "</body>"
    file.puts "</html>"
    file.close
  end
end
