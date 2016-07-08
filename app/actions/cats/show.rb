class Cats::Show

  def initialize id:, cat_repo: CatRepository.new
    @id = id
    @cat_repo = cat_repo
  end

  def call
    ActionResult.new cat: cat
  end

  private

  def cat
    @cat_repo.find @id, includes: [ :photos, :virtual_cats, options: [ variations: [ :photo ] ] ]
  end
end