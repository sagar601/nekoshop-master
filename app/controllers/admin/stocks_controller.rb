class Admin::StocksController < ApplicationController
  before_action :authenticate_user!

  def index
    @result = Admin::Stocks::Index.new(user: current_user, params: params.to_unsafe_h).call
  end

  def edit
    @result = Admin::Stocks::Edit.new(user: current_user, cat_id: params['id']).call
  end

  def update
    @result = Admin::Stocks::Update.new(user: current_user, cat_id: params['id'], params: params.to_unsafe_h).call

    if @result.updated?
      redirect_to admin_stocks_url, notice: user_message(:stock_updated)
    else
      render :edit
    end
  end

end