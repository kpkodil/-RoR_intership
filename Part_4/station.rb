class Station
  attr_reader :trains_list, :name, :all_stations

  include InstanceCounter

  @@all_stations = []

  def self.all
    @@all_stations
  end

  def initialize(name)
    @name = name
    @trains_list = []
    @@all_stations << self
  end

  def show_trains_types
    types_list = []
    types_hash = Hash.new { 0 }
    trains_list.each { |train| types_list << train.train_type }
    types_list.each { |type| types_hash[type] += 1 }
    types_hash
  end

  def delete_train(train)
    return unless trains_list.include?(train)

    trains_list.delete(train)
  end
end
