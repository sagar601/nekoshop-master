require 'test_helper'

describe Components::Flash do

  let(:flash_stub) { { 'notice' => 'lorem ipsum', 'alert' => 'dolor sit' } }

  it 'has one message for each context flash message' do
    flash = Components::Flash.new OpenStruct.new flash: {}
    flash.messages.empty?.must_equal true

    flash = Components::Flash.new OpenStruct.new flash: flash_stub
    flash.messages.count.must_equal 2
  end

  describe 'each message' do

    let(:flash) { flash = Components::Flash.new OpenStruct.new flash: flash_stub }

    it 'has correct type classes' do
      flash.messages.first.classes.must_equal 'positive'
      flash.messages.second.classes.must_equal 'negative'
    end

    it 'has the message text' do
      flash.messages.first.text.must_equal 'lorem ipsum'
      flash.messages.second.text.must_equal 'dolor sit'
    end
  end
end