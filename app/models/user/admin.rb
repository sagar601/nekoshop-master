class User::Admin < User

  def guest?
    false
  end

  def admin?
    true
  end

  def registered?
    true
  end
end