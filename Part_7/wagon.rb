# frozen_string_literal: true

class Wagon
  WAGON_FORMAT = /^\d{2}$/.freeze

  require './modules/company_name'
  require './modules/instance_counter'

  attr_reader :wagon_type, :number
  attr_accessor :company

  include CompanyName
  include InstanceCounter

  def initialize(number, _seats)
    @number = number
    register_instance
    @wagon_type = wagon_type
    @company = company
    validate!
  end

  def validate!
    raise if @number !~ WAGON_FORMAT
  end
end
