require 'test_helper'

describe ::Components::Site::MenuBar do

  it 'has a user' do
    user = Object.new
    bar = ::Components::Site::MenuBar.new user: user

    bar.user.must_equal user
  end
end