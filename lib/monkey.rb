# Monkeys try to mimic things but raise tantrums when they have nothing to imitate.
#
# Use to create test doubles that check if the methods still exist on the original class,
# giving you an early warning of interface changes without increasing your test effort.
#
class Monkey

  CannotImitateError = Class.new RuntimeError

  def initialize guarded_class, **guarded_methods
    @guarded_class = guarded_class

    guarded_methods.each do |method, return_value|
      assert_defined! method and define_singleton_method(method) { |*args| return_value }
    end
  end

  def assert_defined! method
    @guarded_class.instance_methods(false).include? method or
      raise CannotImitateError, "cannot imitate #{@guarded_class.name}##{method}: class does not implement method"
  end


  # Stubs methods on an object while checking that the object still implements them.
  # Useful for stubbing objects consumed by APIs that typecheck on class, in particular, AR's association setters.
  #
  def self.imitate object, **guarded_methods
    guarded_methods.each do |method, return_value|
      raise CannotImitateError, "cannot imitate ##{method}: #{object} does not implement method" unless object.respond_to? method

      object.define_singleton_method(method) { |*args| return_value }
    end

    object
  end

end