D = React.DOM

visible_in_window = (element) ->
  element.getBoundingClientRect().top < $(window).height()

@InfiniteScroller = React.createClass

  getInitialState: ->
    out_of_items: false
    loading: false
    page: 1

  container: ->
    @scroll_container ||= $("[data-infinite-scroll=#{ @props.container }]")

  url: ->
    @props.url

  disabled: ->
    @state.out_of_items || @state.loading

  componentDidMount: ->
    $(window).scroll @scroll_spy

  componentWillUnmount: ->
    $(window).off 'scroll', @scroll_spy

  render: ->
    D.button
      className: 'ui basic button'
      disabled: @disabled()
      onClick: @load_next_page
      ref: (button) => @button = button
      @button_message()

  button_message: ->
    if @state.loading
      D.span {},
        D.i { className: 'github alternate loading icon' }
        t('components.infinite_scroller.loading')
    else if @state.out_of_items
      t('components.infinite_scroller.no_more_items')
    else
      t('components.infinite_scroller.show_more')

  load_next_page: ->
    next_page = @state.page + 1

    @setState loading: true

    @request_page(next_page)
      .done (contents) =>

        if contents.length > 0
          @last_container_child().after contents
          @setState page: next_page
        else
          @setState out_of_items: true

      .always => @setState loading: false

  last_container_child: ->
    @container().children(':not([data-infinite-scroll-exclude])').last()

  request_page: (page) ->
    url = @url() + "?page=#{page}&" + window.location.search.substr(1)
    $.get url

  scroll_spy: _.throttle ->
    @button.click() if @button? && !@disabled() && visible_in_window(@button)
  , 1000

