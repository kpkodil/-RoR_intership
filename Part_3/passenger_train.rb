class PassengerTrain < Train
  def initialize(name)
    super
    @train_type = :passenger
  end
end
