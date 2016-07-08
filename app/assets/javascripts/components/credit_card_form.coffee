D = React.DOM

@CreditCardForm = React.createClass

  getInitialState: ->
    number: '4242 4242 4242 4242'
    busy: false
    error: null

  render: ->
    D.div
      className: 'CreditCardForm'
      D.form
        className: 'ui form'
        ref: (form) => @form = form
        onSubmit: @request_token
        action: @props.action
        method: 'POST'
        @render_error()
        @render_inputs()
        @render_hidden_inputs()
        @render_remember_field()
        @render_submit_button()

  render_hidden_inputs: ->
    [
      @render_meta_hidden_inputs()
      D.input key: 'hct', type: 'hidden', name: 'card[token]', value: @state.token
      D.input key: 'hcb', type: 'hidden', name: 'card[brand]', value: @state.brand
      D.input key: 'hcl', type: 'hidden', name: 'card[last4]', value: @state.last4
      D.input key: 'hcm', type: 'hidden', name: 'card[exp_month]', value: @state.exp_month
      D.input key: 'hcy', type: 'hidden', name: 'card[exp_year]', value: @state.exp_year
    ]

  render_meta_hidden_inputs: ->
    csrf_param = $('[name=csrf-param]').attr('content')
    csrf_token = $('[name=csrf-token]').attr('content')

    [
      D.input key: 'hc', type: 'hidden', name: 'commit', defaultValue: 'use_new_card'
      D.input key: 'hm', type: 'hidden', name: '_method', defaultValue: @props.method
      D.input key: 'hat', type: 'hidden', name: csrf_param, defaultValue: csrf_token
    ]

  render_inputs: ->
    [
      @render_card_number_field()
      @render_expiration_date_fields()
      @render_cvc_field()
    ]

  render_card_number_field: ->
    D.div
      key: 'cn'
      className: 'field'
      D.label
        htmlFor: 'cc_number'
        @t('card_number')
      D.input
        id: 'cc_number'
        required: true
        placeholder: '4242 4242 4242 4242'
        autoComplete: false
        'data-stripe': 'number'
        defaultValue: @state.number

  render_expiration_date_fields: ->
    D.div
      key: 'cd'
      className: 'field'
      D.label
        htmlFor: 'cc_exp_month'
        @t('expiration_date')
      D.div
        className: 'two fields'
        D.div
          className: 'field'
          D.input
            type: 'number'
            id: 'cc_exp_month'
            required: true
            min: 1
            max: 12
            step: 1
            placeholder: 'MM'
            autoComplete: false
            'data-stripe': 'exp-month'
            defaultValue: @state.exp_month
        D.div
          className: 'field'
          D.input
            type: 'number'
            id: 'cc_exp_year'
            required: true
            placeholder: 'YYYY'
            autoComplete: false
            'data-stripe': 'exp-year'
            defaultValue: @state.exp_year

  render_cvc_field: ->
    D.div
      key: 'cv'
      className: 'field'
      D.label
        htmlFor: 'cc_cvc'
        @t('cvc')
      D.input
        id: 'cc_cvc'
        required: true
        placeholder: 'NNN'
        autoComplete: false
        'data-stripe': 'cvc'
        defaultValue: @state.cvc

  render_remember_field: ->
    if @props.rememberable
      D.div
        className: 'field'
        D.div
          className: 'ui checkbox'
          D.input
            type: 'checkbox',
            name: 'remember_card',
            defaultValue: true,
            defaultChecked: true
          D.label {}, @t('remember_this_card')

  render_submit_button: ->
    button_message = if @state.busy
      [ D.i(key: 'omg', className: 'asterisk loading icon'), @t('verifying_card') ]
    else
      @t('use_this_card')

    D.button
      className: 'ui fluid teal button'
      disabled: @state.busy
      button_message

  render_error: ->
    D.div className: 'ui negative message', @state.error if @state.error

  request_token: (event) ->
    event.preventDefault()

    @setState error: null, busy: true

    Stripe.card.createToken @form, @receive_token

  receive_token: (status, response) ->
    if response.error
      @setState
        error: response.error.message
        busy: false
    else
      @setState
        token: response.id
        brand: response.card.brand
        last4: response.card.last4
        exp_month: response.card.exp_month
        exp_year: response.card.exp_year

      $(@form).submit()

  t: (key) ->
    t "components.credit_card_form.#{key}"

