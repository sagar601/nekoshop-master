class Checkout::StepsController < ApplicationController

  rescue_from CheckoutExpiredError do redirect_to cart_url end

end