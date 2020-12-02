# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods

    def validate(atr, valid_type, *parameters)
    	@@validations ||= []
    	@@validations << {:atr => atr, :valid_type => valid_type, :option => parameters.first}

    end 

    def get_validations
    	@@validations	
     end 
  end

  module InstanceMethods
    def validate!
      validations = self.class.get_validations     
     	validations.each do |validation|     		
     		atr = validation[:atr]
     		value = instance_variable_get("@#{atr}".to_sym)
     		p "value is: #{value}"
     		valid_type = validation[:valid_type]
     		p "valid type is: #{valid_type}"
     		parameter = validation[:option]
     		p "parameter is #{parameter}"
	      case valid_type
	      when :presence
	        validate_presence(value.to_str)
	      when :format
	        validate_format(value, parameter)
	      when :type
	        validate_type(value, parameter)
	      end
	    end
    end

    def validate_presence(value)
      raise if value.nil? || value.empty?

      p 'presence validation successfully complited'
    end

    def validate_format(value, pattern)
      raise NameError if value !~ pattern

      p 'format validation successfully complited'
    end

    def validate_type(value, type)
      raise TypeError if value.class != type

      p 'type validation successfully complited'
    end
  end
end

class Test
  include Validation

  attr_accessor :name, :number

end

t = Test.new
Test.validate :name, :format, /[a-c]{3}/
Test.validate :name, :presence
Test.validate :number, :type, Integer
t.name = 'aaa'
t.number = 123
t.validate!

