class Admin::Cats::Index

  def initialize user:, params:, cat_repo: CatRepository.new, auth: AuthService.new
    @user = user
    @params = params
    @repo = cat_repo
    @auth = auth
  end

  def call
    @auth.authorize_admin @user, self.class

    ActionResult.new cats: cats
  end

  private

  def cats
    @repo.all includes: [ :headshot ], page: page
  end

  def page
    @params['page'] || 1
  end

end