class PassengerWagon < Wagon
  def initialize(name)
    @wagon_type = :passenger
    super
  end
end
