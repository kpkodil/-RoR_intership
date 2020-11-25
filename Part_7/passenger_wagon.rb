# frozen_string_literal: true

class PassengerWagon < Wagon
  attr_reader :vacant_seats, :taken_seats

  def initialize(number, vacant_seats)
    @wagon_type = :passenger
    @vacant_seats = vacant_seats
    @taken_seats = 0
    super
  end

  def take_seat
    if @vacant_seats.positive?
      @taken_seats += 1
      @vacant_seats -= 1
    end
  end
end
