class User::Guest < User

  def guest?
    true
  end

  def admin?
    false
  end

  def registered?
    false
  end

end