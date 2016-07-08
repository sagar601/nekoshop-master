class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @result = Orders::Index.new(user: current_user, params: params.to_unsafe_h).call
  end

end