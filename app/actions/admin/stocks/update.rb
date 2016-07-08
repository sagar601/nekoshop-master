class Admin::Stocks::Update

  def initialize user:, cat_id:, params:, cat_repo: CatRepository.new, auth: AuthService.new
    @user = user
    @cat_id = cat_id
    @params = params
    @repo = cat_repo
    @auth = auth
  end

  def call
    @auth.authorize_admin @user, self.class

    success = form.validate @params['stock']

    transaction{ form.save or raise 'unexpected save failure' } if success

    ActionResult.new updated?: success, form: form, cat: cat
  end

  private

  def form
    @form ||= Forms::Admin::CatStockForm.new cat
  end

  def cat
    @cats ||= @repo.find @cat_id, includes: [ :headshot, :virtual_cats ]
  end

  def transaction &block
    ActiveRecord::Base.transaction &block
  end

end