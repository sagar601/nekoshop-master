require 'test_helper'

describe VirtualCatRepository do

  before do
    Cat.create name: 'Spotty', virtual_cats: [VirtualCat.new(id: 12)]
  end

  let(:repo) { VirtualCatRepository.new }

  describe '#find' do

    it 'finds virtual cats by id' do
      virtual_cat = repo.find 12

      virtual_cat.must_be_instance_of VirtualCat
      virtual_cat.id.must_equal 12
    end

    it 'raises an error if not found' do
      proc{ repo.find nil }.must_raise ActiveRecord::RecordNotFound
    end
  end

end