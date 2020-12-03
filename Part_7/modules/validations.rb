# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(atr, valid_type, *parameters)
      @validations ||= []
      @validations << { atr: atr, valid_type: valid_type, option: parameters }
    end

    def get_validations
      @validations
    end
  end

  module InstanceMethods
    def validate!
      validations = self.class.get_validations
      validations.each do |validation|
        send "validate_#{validation[:valid_type]}", instance_variable_get("@#{validation[:atr]}"), validation[:option].first
      end
    end

    def validate_presence(value, _option)
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