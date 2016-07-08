require 'set'

module Minitest::Assertions

  def assert_contains container, elements
    assert contains(container, elements),
      "Expected #{container.inspect} to contain all of these: #{elements.inspect}"
  end

  def refute_contains container, elements
    refute contains(container, elements),
      "Expected #{container.inspect} to not contain all of these: #{elements.inspect}"
  end

  private

  def contains container, elements
    raise ArgumentError, 'container must be enumerable' unless container.kind_of? Enumerable
    raise ArgumentError, 'elements must be an enumerable' unless elements.kind_of? Enumerable
    raise ArgumentError, 'you must provide at least one expected element' if elements.empty?

    Set.new(container) >= Set.new(elements)
  end

end


module Minitest::Expectations
  Object.infect_an_assertion :assert_contains, :must_contain, true
  Object.infect_an_assertion :refute_contains, :wont_contain, true
end