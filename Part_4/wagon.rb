class Wagon
	
require_relative 'company_name'
require_relative 'instance_counter'

  attr_reader :wagon_type
  attr_accessor :company

  include CompanyName
  include InstanceCounter

  @instances = 0

  def initialize(name)
    @name = name
    @wagon_type = wagon_type
    @company = self.set_company_name
    register_instance

  end
end
