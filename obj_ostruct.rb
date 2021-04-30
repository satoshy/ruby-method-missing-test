require "ostruct"
require 'active_support/core_ext/string'

class ObjOstruct
  class << self
    def ostruct_to_h(object)
      object.to_h.stringify_keys.transform_values do |value|
        value.is_a?(Obj) ? ostruct_to_h(value) : value.is_a?(Array) ? value.map{|v| v.is_a?(String) ? v : ostruct_to_h(v) } : value
      end
    end

    def recursive_ostruct(name, obj)
      case obj
      when Hash
        hash = {}; obj.each{|k,v| hash[k] = recursive_ostruct(k,v)}
        new_obj(name,hash)
      when Array
        obj.map {|e| recursive_ostruct(name, e) }
      else
        obj
      end
    end

    private
    def new_obj(name,hash)
      class_name = name.capitalize.singularize
      open_struct_class = Class.new(OpenStruct)
      if Object.const_defined?(class_name) 
        Object.const_get(class_name).new(hash) 
      else 
        Object.const_set(class_name, open_struct_class).new(hash)
      end
    end
  end
end