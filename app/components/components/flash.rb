class Components::Flash

  def initialize context
    @messages = context.flash.map do |type, message|
      OpenStruct.new text: message, classes: classes_for(type)
    end
  end

  attr_reader :messages

  private

  def classes_for type
    @class_map ||= {
      'notice' => 'positive',
      'alert'  => 'negative',
    }

    @class_map[type]
  end

end