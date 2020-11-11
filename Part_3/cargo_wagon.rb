class CargoWagon < Wagon

  def initialize(name)
  	super
  	@wagon_type = :cargo
  end
end