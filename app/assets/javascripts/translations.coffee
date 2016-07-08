translations =
  en:
    components:
      photo_roll:
        no_photos_available: "Unfortunately we don't have any photos of this cat."

      infinite_scroller:
        loading: 'loading...'
        no_more_items: 'There are no more items to show.'
        show_more: 'Show More'

      credit_card_form:
        card_number: 'Card Number'
        expiration_date: 'Expiration Date'
        cvc: 'CVC'
        remember_this_card: 'Use this card in future purchases'
        use_this_card: 'Use this card'
        verifying_card: 'Verifying card...'

      recombobulator:
        choose: 'Choose'
        choose_options: 'Please choose your options'
        available: 'Available'
        out_of_stock: 'Out of stock'
        add_to_cart: 'Add to Cart'


humanize = (key_string) ->
  _(key_string).split('.').last().replace /_/g, ' '

@t = (key) ->
  locale = @LOCALE || 'en'
  dictionary = translations[locale]
  fallback = humanize key

  _.get dictionary, key, fallback