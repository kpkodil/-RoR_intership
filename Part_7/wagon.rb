# frozen_string_literal: true

class Wagon
  WAGON_FORMAT = /^\d{2}$/.freeze

  require './modules/company_name'
  require './modules/instance_counter'
  require './modules/accessors'
  require './modules/validations'

  attr_reader :wagon_type, :number
  attr_accessor :company

  include CompanyName
  include InstanceCounter
  include Accessors
  include Validation

  validate :number, :format, WAGON_FORMAT

  def initialize(number, _option)
    @number = number
    register_instance
    @wagon_type = wagon_type
    @company = company
    validate!
  end
end
