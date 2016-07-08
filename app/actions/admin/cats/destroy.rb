class Admin::Cats::Destroy

  def initialize user:, cat_id:, cat_repo: CatRepository.new, auth: AuthService.new
    @user = user
    @cat_id = cat_id
    @repo = cat_repo
    @auth = auth
  end

  def call
    @auth.authorize_admin @user, self.class

    cat.destroy! unless cat.nil?

    ActionResult.new cat: cat
  end

  private

  def cat
    @cat ||= @repo.find @cat_id
  end

end