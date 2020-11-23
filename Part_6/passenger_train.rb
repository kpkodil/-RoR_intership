# frozen_string_literal: true

class PassengerTrain < Train
  def initialize(number)
    super
    @train_type = :passenger
  end
end
