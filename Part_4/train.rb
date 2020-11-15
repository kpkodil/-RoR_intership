class Train
  require './modules/company_name'
  require './modules/instance_counter'

  attr_reader :speed, :number, :wagon_list, :train_type, :train_route, :train_station, :index_station, :trains_list

  include CompanyName
  include InstanceCounter

  @@trains_list = {}

  def self.find
    p 'Введите название поезда'
    p @@trains_list[gets.chomp]
  end

  def initialize(number)
    @number = number
    @train_type = train_type
    @wagon_list = []
    @speed = 1
    @@trains_list.merge!({ number => self })
    register_instance
  end

  def accelerate(speed)
    return unless speed.positive?

    @speed += speed
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    return unless speed.zero? && train_type == wagon.wagon_type

    wagon_list << wagon
  end

  def remove_wagon(wagon)
    return unless speed.zero? && train_type == wagon.wagon_type

    wagon_list.delete(wagon)
  end

  # ДОБАВИТЬ УДАЛЕНИЕ СО СТАНЦИИ ПРИ ПЕРЕХОДЕ НА НОВЫЙ МАРШРУТ
  def take_route(route)
    @train_route = route
    @train_station = route.stations[0]
    @train_route.stations[0].trains_list << self
    @train_route
  end

  def move_forward
    return unless speed.positive? && next_station

    next_station.trains_list << self
    @train_station = next_station
    previous_station.trains_list.delete(self)
    @train_station
  end

  def move_back
    return unless speed.positive? && previous_station

    previous_station.trains_list << self
    @train_station = previous_station
    next_station.trains_list.delete(self)
    @train_station
  end

  def previous_station
    i = @train_route.stations.index(@train_station)
    return unless i.positive?

    @train_route.stations[i - 1]
  end

  def next_station
    i = @train_route.stations.index(@train_station)
    return unless i < (@train_route.stations.size - 1)

    @train_route.stations[i + 1]
  end
end
