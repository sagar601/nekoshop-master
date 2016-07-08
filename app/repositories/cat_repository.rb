class CatRepository

  def search params, includes: [], page: 1
    Cat.includes(includes).where(params).page(page)
  end

  def find id, includes: []
    Cat.includes(includes).find(id)
  end

  def all includes: [], page: 1
    Cat.includes(includes).all.page(page)
  end

end