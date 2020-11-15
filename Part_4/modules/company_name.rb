module CompanyName
  attr_accessor :company

  def set_company_name
    self.company = gets.chomp
  end

  def get_company_name
    p company
  end
end

