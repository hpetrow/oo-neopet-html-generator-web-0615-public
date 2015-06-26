class Neopet
  # attrs here
  attr_accessor :happiness, :items
  attr_reader :name, :strength, :defence, :movement, :species

  # initialize here
  def initialize(name)
    @name = name
    @strength = get_points
    @defence = get_points
    @movement = get_points
    @happiness = get_points
    @species = get_species
    @items = []
  end

  # other methods here
  def get_points
    rand(1..10)
  end

  def get_species
    items = Dir["public/img/neopets/*"]
    type = items[rand(1...items.count)]
    type.gsub("public/img/neopets/", "").gsub(".jpg", "")
  end

  def mood
    if happiness <= 2
      @mood = "depressed"
    elsif happiness <= 4
      @mood = "sad"
    elsif happiness <= 6
      @mood = "meh"
    elsif happiness <= 8
      @mood = "happy"
    elsif happiness <= 10
      @mood = "ecstatic"
    end
  end
end
