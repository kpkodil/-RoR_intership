# frozen_string_literal: true

class CargoTrain < Train
  def initialize(number)
    super
    @train_type = :cargo
  end
end
