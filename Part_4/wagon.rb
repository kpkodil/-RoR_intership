class Wagon
  attr_reader :wagon_type
  attr_accessor :company

  include CompanyName

  def initialize(name)
    @name = name
    @wagon_type = wagon_type
    @company = set_company_name
    register_instance
  end
end
