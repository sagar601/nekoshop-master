class Admin::Cats::Edit

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

  def cat
    @cat ||= if @cat_id == :new
      Cat.new
    else
      @repo.find @cat_id, includes: [ :photos, :virtual_cats, options: [ variations: [ :photo ] ] ]
    end
  end

  def form
    @form ||= ::Forms::Admin::Cats::CatForm.new cat
  end

end