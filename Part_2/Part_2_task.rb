# frozen_string_literal: true

# Station
class Station
  attr_reader :trains_list, :name

  def initialize(name)
    @name = name
    @trains_list = []
  end

  def show_trains
    trains_list.each { |train| p train.name }
  end

  def show_trains_types
    types_list = []
    types_hash = Hash.new { 0 }
    trains_list.each { |train| types_list << train.train_type }
    types_list.each { |type| types_hash[type] += 1 }
    types_hash
  end

  def train_departure(train)
    return unless trains_list.include?(train)

    p 'Куда хотите отправить поезд? (f/b)'
    answer = gets.chomp
    case answer
    when 'f'
      train.move_forward
    when 'b'
      train.move_back
    end
  end
end

# Route
class Route
  attr_reader :name, :stations

  def initialize(base, terminal, _stations = [])
    @base = base
    @terminal = terminal
    @stations = [@base, @terminal]
  end

  def insert_station(station)
    @stations.insert(-2, station) unless @stations.include?(station)
  end

  def remove_station(station)
    @stations.delete(station) if @stations.include?(station)
  end

  def show_stations
    @stations.each { |station| puts station.name }
  end
end

# Train
class Train
  attr_reader :speed, :name, :car_quantity, :train_type, :train_route, :train_station, :index_station

  def initialize(name, train_type, car_quantity = 0)
    @name = name
    @train_type = train_type
    @car_quantity = car_quantity
    @speed = 0
    @train_route = []
    @train_station = nil
  end

  def accelerate(speed)
    return unless speed.positive?

    @speed += speed
  end

  def stop
    @speed = 0
  end

  def add_car
    return unless speed.zero? && car_quantity.positive?

    @car_quantity += 1
  end

  def remove_car
    return unless speed.zero? && car_quantity.positive?

    @car_quantity -= 1
  end

  def take_route(route)
    @train_route = route
    @train_station = route.stations[0]
    @train_route.stations[0].trains_list << self
    @train_route
  end

  def move_forward
    return unless speed.positive? && next_station

    i = @train_route.stations.index(@train_station)
    @train_station = @train_route.stations[i += 1]
    @train_route.stations[i].trains_list << self
    @train_route.stations[i - 1].trains_list.delete(self)
  end

  def move_back
    return unless speed.positive? && previous_station

    i = @train_route.stations.index(@train_station)
    @train_station = @train_route.stations[i -= 1]
    @train_route.stations[i].trains_list << self
    @train_route.stations[i + 1].trains_list.delete(self)
  end

  def previous_station
    i = @train_route.stations.index(@train_station)
    return unless i.positive?

    @train_route.stations[i - 1].name
  end

  def next_station
    i = @train_route.stations.index(@train_station)
    return unless i < (@train_route.stations.size - 1)

    @train_route.stations[i + 1].name
  end
end
