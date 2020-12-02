# frozen_string_literal: true

class Train
  require './modules/company_name'
  require './modules/instance_counter'
  require './modules/accessors'
  require './modules/validations'

  include CompanyName
  include InstanceCounter
  extend Accessors
  include Validation

  attr_reader :speed, :number, :train_type, :train_route, :index_station, :trains_list
  attr_accessor :wagon_list, :company

  attr_accessor_with_history :train_station

  @@trains_list = {}

  TRAIN_NAME = /^([A-Z]{3}|\d{3})-*([A-Z]{2}|\d{2})$/i.freeze

  def self.find
    p 'Введите название поезда'
    p @@trains_list[gets.chomp]
  end

  validate :number, :presence
  validate :number, :format, TRAIN_NAME
  validate :number, :type, String

  def initialize(number)
    @number = number
    @train_type = train_type
    @wagon_list = []
    @speed = 1
    register_instance
    validate!
    @@trains_list.merge!({ number => self })
  end

  def accelerate(speed)
    return unless speed.positive?

    @speed += speed
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    return unless @train_type == wagon.wagon_type

    wagon_list << wagon
  end

  def remove_wagon(wagon)
    return unless train_type == wagon.wagon_type

    wagon_list.delete(wagon)
  end

  def show_wagons(&block)
    wagon_list.each(&block)
  end

  def take_route(route)
    @train_route = route
    @train_station = route.stations[0]
    @train_route.stations[0].trains_list << self
    @train_route
  end

  def move_forward
    return unless speed.positive? && next_station

    next_station.trains_list << self
    @train_station = next_station
    previous_station.trains_list.delete(self)
    @train_station
  end

  def move_back
    return unless speed.positive? && previous_station

    previous_station.trains_list << self
    @train_station = previous_station
    next_station.trains_list.delete(self)
    @train_station
  end

  def previous_station
    i = @train_route.stations.index(@train_station)
    return unless i.positive?

    @train_route.stations[i - 1]
  end

  def next_station
    i = @train_route.stations.index(@train_station)
    return unless i < (@train_route.stations.size - 1)

    @train_route.stations[i + 1]
  end
end
