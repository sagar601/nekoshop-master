class Components::Site::MenuBar

  def initialize user:
    @user = user
  end

  attr_reader :user

end