module ComponentsHelper

  # Simple wrapper around the `partial` helper method to facilitate usage of component objects.
  # By components I mean any object that extracts behaviour and state from the views.
  #
  # Components can be of any class. The rendered partial is determined by calling the `to_partial_path`
  # on the component, if available. Otherwise it defaults to making a path out of the component' s full
  # class name. In the partial template, the component is available as a local variable.
  #
  # For example, we could have in a view:
  #
  #   <h1><%= @article.title %></h1>
  #   <h2>by <%= render_component ::Components::AuthorLink.new author: @author %></h2>
  #
  # Then in `app/views/components/_author_link.html.erb`:
  #
  #   <span class="AuthorRef">
  #     <%= link_to component.full_name, author_path(component.author) %>
  #   </span>
  #
  # And in `app/components/components/author_link.rb`:
  #
  #   class Components::AuthorLink
  #     def initialize author:
  #       @author = author
  #     end
  #
  #     attr_reader :author
  #
  #     def full_name
  #       "#{author.title} #{author.first_name} #{author.last_name}"
  #     end
  #   end
  #
  def render_component component
    partial = component.try(:to_partial_path) || component.class.name.underscore

    render partial: partial, locals: { component: component }
  end

end