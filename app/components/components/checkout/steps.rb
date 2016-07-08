class Components::Checkout::Steps
  include ComponentTranslationHelpers

  def initialize active: 1
    @active = active - 1
  end

  def steps
    @steps ||= build_steps
  end

  private

  def build_steps
    steps = [
      OpenStruct.new(title: t('.shipping_address')),
      OpenStruct.new(title: t('.payment_details')),
      OpenStruct.new(title: t('.confirm_order'))
    ]
    .each_with_index do |step, i|
      step.classes = []
      step.classes << 'active'    if i == @active
      step.classes << 'completed' if i < @active
    end
  end

end