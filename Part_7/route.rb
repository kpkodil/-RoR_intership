# frozen_string_literal: true

require './modules/instance_counter'
require './modules/accessors'
require './modules/validations'

ROUTE_FORMAT = /^[A-Z]{1}[a-z]{1,}$/.freeze

class Route
  attr_reader :name, :stations

  include InstanceCounter
  extend Accessors
  include Validation

  validate :name, :presence
  validate :name, :format, ROUTE_FORMAT
  validate :name, :type, String

  def initialize(name, base, terminal, _stations = [])
    @name = name
    @base = base
    @terminal = terminal
    @stations = [@base, @terminal]
    validate!
  end

  def insert_station(station)
    @stations.insert(-2, station) unless @stations.include?(station)
  end

  def remove_station(station)
    @stations.delete(station) if @stations.include?(station)
  end
end
