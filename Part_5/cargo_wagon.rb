class CargoWagon < Wagon
  def initialize(name)
    @wagon_type = :cargo
    super
  end
end
