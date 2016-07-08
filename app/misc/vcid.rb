# Uniquely identifies a combination of Variations.
#
class Vcid

  def self.build_all_combinations options
    id_arrays = options.map &:variation_ids

    return [Vcid.new] if id_arrays.flatten.empty?

    first, *rest = id_arrays
    combinations = first.product *rest

    combinations.map &method(:new)
  end

  def initialize ids = []
    @ids = Set.new ids
  end

  def include? variation_or_id
    id = variation_or_id.try(:id) || variation_or_id.to_i

    @ids.include? id
  end

  def to_a
    @ids.to_a.sort
  end

  def == other
    other.is_a?(Vcid) && other.id_set == self.id_set
  end

  def eql? other
    other == self
  end

  def hash
    id_set.hash
  end

  def singular?
    @ids.empty?
  end

  protected

  def id_set
    @ids
  end

end