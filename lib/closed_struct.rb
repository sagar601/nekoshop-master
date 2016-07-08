require 'ostruct'

# Like OpenStruct except it throws errors for methods not specified in initialize.
#
class ClosedStruct < OpenStruct

  def initialize **args
    super **args
  end

  def method_missing method, *args
    raise NoMethodError, "undefined method '#{method}' for #{self.class}"
  end

end