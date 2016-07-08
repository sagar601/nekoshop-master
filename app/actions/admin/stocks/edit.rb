class Admin::Stocks::Edit

  def initialize user:, cat_id:, cat_repo: CatRepository.new, auth: AuthService.new
    @user = user
    @cat_id = cat_id
    @repo = cat_repo
    @auth = auth
  end

  def call
    @auth.authorize_admin @user, self.class

    ActionResult.new form: form, cat: cat
  end

  private

  def form
    @form ||= Forms::Admin::CatStockForm.new cat
  end

  def cat
    @cats ||= @repo.find @cat_id, includes: [ :headshot, :virtual_cats ]
  end

end