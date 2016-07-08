class Admin::Cats::Update

  def initialize user:, cat_id:, params:, cat_repo: CatRepository.new, auth: AuthService.new
    @user = user
    @cat_id = cat_id
    @params = params
    @repo = cat_repo
    @auth = auth
  end

  def call
    @auth.authorize_admin @user, self.class

    success = form.validate cat_params

    transaction{ form.save or raise 'unexpected save failure' } if success

    ActionResult.new updated?: success, form: form, cat: cat
  end

  private

  def cat_params
    @params['cat']
  end

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

  def transaction &block
    ActiveRecord::Base.transaction &block
  end

end