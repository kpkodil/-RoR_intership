# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(atr, valid_type, *parameters)
      if block_given?
        yield
        value = atr
        p "value after block is: #{value}"
        p "atr after block is: #{atr}"
        p "valid_type after block is: #{valid_type}"
        p "parameter after block is: #{parameters}"
      else
        value = class_variable_get("@@#{atr}".to_sym)
      end
      case valid_type
      when :presence
        validate_presence(value)
      when :format
        validate_format(value, parameters.first)
      when :type
        validate_type(value, parameters.first)
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

  module InstanceMethods
    def validate!(atr, atr_format, atr_type)
      atr = instance_variable_get("@#{atr}".to_sym)
      types_values = { presence: [nil, atr], format: [atr_format, atr], type: [atr_type, atr] } # Как по-другому передать atr в метод validate извне? Чтобы не повторяться здесь.
      types_values.each do |type_value|
        p ''
        p 'Validating...'
        self.class.validate(type_value[1][1], type_value[0], type_value[1][0]) { |atr| } # Правильно ли передаввать пустой блок?
      end
    end
  end
end

class Test
  include Validation

  attr_accessor :name, :number

  @@atr = 'abc'
end

t = Test.new
# Test.validate :atr, :format, /[a-c]{3}/
t.name = 'aaa'
t.validate! :name, /[a-c]{3}/, String
