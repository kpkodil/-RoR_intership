class PassengerWagon < Wagon
  def initialize(name)
    super
    @wagon_type = :passenger
  end
end
