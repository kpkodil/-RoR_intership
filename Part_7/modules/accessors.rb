# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}_history".to_sym) { instance_variable_get("@#{name}_history".to_sym) }
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        instance_variable_get("@#{name}_history".to_sym) || instance_variable_set("@#{name}_history".to_sym, [])
        instance_variable_get("@#{name}_history".to_sym) << instance_variable_get("@#{name}")
      end
    end
  end

  def strong_attr_accessor(name, type)
    var_name = "@#{name}".to_sym
    var_type = type.to_s.to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
      if value.instance_of?(var_type.to_sym)
        instance_variable_set(var_name, value)
      else
        raise TypeError
      end
    end
  end
end
