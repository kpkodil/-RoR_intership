# НУЖНО СДЕЛАТЬ ПРОВЕРКУ НА СОВПАДЕНИЕ base и terminal !!!
class Route
  attr_reader :name, :stations

  def initialize(name, base, terminal, _stations = [])
    @name = name
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
end
