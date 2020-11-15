class Wagon

	require './modules/company_name'
	require './modules/instance_counter'

  attr_reader :wagon_type
  attr_accessor :company

  include CompanyName
  include InstanceCounter
  
  def initialize(name)
    @name = name
    register_instance
    @wagon_type = wagon_type
  end
end
