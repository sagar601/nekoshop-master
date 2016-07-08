class SpeciesRepository

  def all
    Cat.pluck(:species).map(&:to_s).reject(&:empty?).uniq.sort
  end
end