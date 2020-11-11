class Route
  attr_reader :name, :stations

  def initialize(base, terminal, stations = [])
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