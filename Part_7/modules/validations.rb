# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(atr, valid_type, *parameters)
      @validations ||= []
      @validations << { atr: atr, valid_type: valid_type, option: parameters.first }
    end

    def get_validations
      @validations
    end
  end

  module InstanceMethods
    def validate!
      validations = self.class.get_validations
      validations.each do |validation|
        atr = validation[:atr]
        value = instance_variable_get("@#{atr}".to_sym)
        valid_type = validation[:valid_type]
        parameter = validation[:option]
        case valid_type
        when :presence
          validate_presence(value)
        when :type
          validate_type(value, parameter)
        when :format
          validate_format(value, parameter)
        end
      end
    end

    def validate_presence(value)
      raise StandardError if value.nil? || value.to_s.empty?
    end

    def validate_format(value, pattern)
      raise NameError if value.to_s !~ pattern
    end

    def validate_type(value, type)
      raise TypeError if value.class != type
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    rescue NameError
      false
    rescue TypeError
      false
    end
  end
end
