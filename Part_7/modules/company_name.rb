# frozen_string_literal: true

require './modules/validations'

module CompanyName
  include Validation
  attr_accessor :company_name

  COMPANY_FORMAT = /^[A-Z]{1}[a-z]{1,}$/.freeze

  validate :company_name, :presence
  validate :company_name, :format, COMPANY_FORMAT
  validate :company_name, :type, String

  def set_company_name(company_name)
    @company = company_name
  end

  def get_company_name
    p company
  end
end
