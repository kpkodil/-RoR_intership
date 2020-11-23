# frozen_string_literal: true

class CargoWagon < Wagon
  attr_reader :free_volume, :occupied_volume

  def initialize(number, free_volume)
    @wagon_type = :cargo
    @free_volume = free_volume
    @occupied_volume = 0
    super
  end

  def occupy_volume(volume)
    if (@free_volume - volume) >= 0
      @occupied_volume += volume
      @free_volume -= volume
    else
      raise
    end
  end
end
