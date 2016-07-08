require "test_helper"

describe OrderMailer do

  it "has a new_order email" do
    OrderMailer.respond_to? :new_order
  end

end
