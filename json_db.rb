require 'json'
require_relative 'obj_ostruct'

class JsonDb
  
  def initialize(json_filename)
    @json_filename = json_filename
  end

  attr_reader :json_filename
  
  def data
    @data ||= JSON.parse(IO.read(json_filename))
  end

  private
  def method_missing(method_name, *args, &block)
    @object_data ||= ObjOstruct.recursive_ostruct('Obj', data)
    serialize(@object_data)
    @object_data[method_name.to_s]
  end
  
  # Use this method to store updated properties on disk
  def serialize(object_data)
    object_hash = ObjOstruct.ostruct_to_h(@object_data)
    @data = object_hash if object_hash != @data
    
    IO.write(json_filename, @data.to_json)
  end
end