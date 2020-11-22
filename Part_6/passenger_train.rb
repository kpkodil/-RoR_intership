class PassengerTrain < Train
  def initialize(number)
    super
    @train_type = :passenger
  end
end
