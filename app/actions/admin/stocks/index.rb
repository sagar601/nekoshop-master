class Admin::Stocks::Index

  def initialize user:, params:, cat_repo: CatRepository.new, auth: AuthService.new
    @user = user
    @params = params
    @repo = cat_repo
    @auth = auth
  end

  def call
    @auth.authorize_admin @user, self.class

    ActionResult.new stocks: stocks, cats: cats
  end

  private

  Stock = Struct.new :cat, :quantity

  def stocks
    @stocks ||= cats.map{ |cat| Stock.new cat, cat.stock }
  end

  def cats
    @cats ||= @repo.all includes: [ :headshot, :virtual_cats ], page: page
  end

  def page
    @params['page'] || 1
  end

end