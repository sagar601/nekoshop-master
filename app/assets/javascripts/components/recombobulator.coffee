D = React.DOM

@Recombobulator = React.createClass

  getInitialState: ->
    chosen_options: {}

  render: ->
    D.div({},
      @variation_selectors(),
      @stock_notification(),
      @price_tag(),
      @hidden_input(),
      @submit_button()
    )

  variation_selectors: ->
    @cat().options.map @build_variation_selector

  build_variation_selector: (option) ->
    D.select
      key: option.id
      name: option.name
      defaultValue: 0
      onChange: @variation_selected
      @build_variation_selector_options(option)

  build_variation_selector_options: (option) ->
    head = D.option key: 0, value: 0, disabled: true, "#{t('components.recombobulator.choose')} #{option.name}"
    options = option.variations.map (v) -> D.option(key: v.id, value: v.id, v.name)

    [head].concat(options)

  stock_notification: ->
    [message, color] = if @needs_more_options()
      [t('components.recombobulator.choose_options'), 'blue']
    else switch @in_stock()
      when true then [t('components.recombobulator.available'), 'green']
      when false then [t('components.recombobulator.out_of_stock'), 'red']

    D.div {}, D.div({ className: "ui tag #{color} label" }, message)

  price_tag: ->
    D.div { className: 'ui tag large label' }, @price()

  hidden_input: ->
    D.input type: 'hidden', name: 'item[virtual_cat_id]', value: @chosen_virtual_cat().id

  submit_button: ->
    D.button
      className: 'ui fluid teal button'
      disabled: @in_stock() != true
      D.i className: 'ui cart icon'
      t('components.recombobulator.add_to_cart')


  # event handlers

  variation_selected: (event) ->
    [option_name, variation_id] = [event.target.name, parseInt(event.target.value)]

    new_chosen = _.clone @state.chosen_options
    new_chosen[option_name] = variation_id

    @replaceState chosen_options: new_chosen


  # helpers

  cat: ->
    @props.cat

  virtual_cats: ->
    @cat().virtual_cats

  chosen_virtual_cat: ->
    vcid = _.values(@state.chosen_options).sort()
    cat = _.find @virtual_cats(), (cat) -> _.isEqual(cat.vcid, vcid)

    cat || { price: @cat().price, stock: 0 }

  price: ->
    @chosen_virtual_cat().price

  in_stock: ->
    @chosen_virtual_cat().stock > 0

  needs_more_options: ->
    _(@state.chosen_options).values().compact().value().length < @cat().options.length
