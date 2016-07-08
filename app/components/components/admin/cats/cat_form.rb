class Components::Admin::Cats::CatForm

  def initialize context:, form:, action:, method: :post, return_path:
    @context = context
    @form = form.prepopulate!
    @action = action
    @method = method
    @return_path = return_path
  end

  attr_reader :form, :action, :method, :return_path

  def errors
    if @form.errors.any?
      messages = @form.errors.full_messages
      messages = messages.map{ |msg| @context.content_tag :li, msg }

      @context.content_tag :div, class: 'ui negative message FormValidationErrors' do
        @context.content_tag :ul, messages.join.html_safe
      end
    end
  end

end