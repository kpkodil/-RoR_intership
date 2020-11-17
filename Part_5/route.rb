require './modules/instance_counter'

ROUTE_FORMAT = /^[A-Z]{1}[a-z]{1,}$/.freeze

class Route
  attr_reader :name, :stations

  include InstanceCounter

  def initialize(name, base, terminal, _stations = [])
    @name = name
    @base = base
    @terminal = terminal
    @stations = [@base, @terminal]
    validate!
  end

  def validate!
    raise if @name !~ ROUTE_FORMAT
  end

  def insert_station(station)
    @stations.insert(-2, station) unless @stations.include?(station)
  end

  def remove_station(station)
    @stations.delete(station) if @stations.include?(station)
  end
end
