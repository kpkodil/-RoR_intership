module CompanyName
  attr_accessor :company

  COMPANY_FORMAT = /^[A-Z]{1}[a-z]{1,}$/.freeze

  def set_company_name
    self.company = gets.chomp
    raise if company !~ COMPANY_FORMAT
  end

  def get_company_name
    p company
  end
end
