class Admin::CatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @result = Admin::Cats::Index.new(user: current_user, params: params.to_unsafe_h).call
  end

  def edit
    @result = Admin::Cats::Edit.new(user: current_user, cat_id: params[:id]).call
  end

  def update
    @result = Admin::Cats::Update.new(user: current_user, cat_id: params[:id], params: params.to_unsafe_h).call

    if @result.updated?
      redirect_to admin_cats_url, notice: user_message(:successfully_updated_cat, cat_name: @result.cat.name)
    else
      render :edit
    end
  end

  def new
    @result = Admin::Cats::Edit.new(user: current_user, cat_id: :new).call
  end

  def create
    @result = Admin::Cats::Update.new(user: current_user, cat_id: :new, params: params.to_unsafe_h).call

    if @result.updated?
      redirect_to admin_cats_url, notice: user_message(:successfully_created_cat, cat_name: @result.cat.name)
    else
      render :new
    end
  end

  def destroy
    result = Admin::Cats::Destroy.new(user: current_user, cat_id: params[:id]).call

    redirect_to admin_cats_url, notice: user_message(:cat_was_destroyed, cat_name: result.cat.name)
  end

end