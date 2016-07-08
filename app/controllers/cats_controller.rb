class CatsController < ApplicationController

  def index
    @result = Cats::Index.new(params: params.to_unsafe_h).call

    render 'cats/scroll_page', layout: false if params.has_key? 'page'
  end

  def show
    @result = Cats::Show.new(id: params[:id]).call
  end
end