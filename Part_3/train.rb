class Train
  attr_reader :speed, :name, :wagon_list, :train_type, :train_route, :train_station, :index_station

  def initialize(name)
    @name = name
    @train_type = train_type
    @wagon_list = []
    @speed = 0
  end

  def accelerate(speed)
    return unless speed.positive?

    @speed += speed
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    return unless speed.zero? && self.train_type == wagon.wagon_type

    self.wagon_list << wagon 
  end

  def remove_wagon(wagon)
    return unless speed.zero? && self.train_type == wagon.wagon_type

    self.wagon_list.delete(wagon)
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
