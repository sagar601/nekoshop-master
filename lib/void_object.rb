class VoidObject

  def method_missing method, *args
    self
  end

  def to_a
    []
  end

end