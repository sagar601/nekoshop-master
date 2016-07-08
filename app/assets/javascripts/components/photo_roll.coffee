D = React.DOM

@PhotoRoll = React.createClass

  getInitialState: ->
    active: _.first @props.photos

  render: ->
    D.div
      className: 'PhotoRoll'
      D.div
        className: 'ui segment'
        @render_photos()

  render_photos: ->
    if @props.photos.length == 0
      @render_no_photos_message()
    else
      @props.photos.map @render_photo

  render_photo: (photo) ->
    active = if photo == @state.active then 'is-active' else ''

    D.img
      key: photo.id
      className: "ui fluid small rounded centered image #{active}"
      src: photo.src
      onClick: _.partial(@select_photo, photo.id)

  render_no_photos_message: ->
    D.div
      className: 'ui centered grey header'
      D.small {}, t('components.photo_roll.no_photos_available')

  select_photo: (photo_id) ->
    photo = _.find @props.photos, 'id', photo_id
    @setState active: photo

    @update_external_screen photo.src

  update_external_screen: (src) ->
    $('[data-photo-roll-screen]').attr('src', src)