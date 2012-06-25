jQuery ->
  $('.dropdown-toggle').dropdown()
  $('a[rel="popover"]').popover(placement: 'bottom')
  
  # disables the submit button if no checkbox is checked
  setSubmit = ->
    if $('.accounts :checkbox:checked').length > 0
      $('input:submit').addClass('btn-primary').prop('disabled', false)
    else
      $('input:submit').removeClass('btn-primary').prop('disabled', true)

  $('.accounts').on 'change', ':checkbox', (event) ->
    $checkbox = $(@)
    if $checkbox.is(':checked')
      $checkbox.closest('.account').addClass('selected')
    else
      $checkbox.closest('.account').removeClass('selected')
    setSubmit()

  $('.accounts').on 'click', ':checkbox', (event) ->
    # prevent recursion
    event.stopPropagation()

  $('.accounts').on 'click', '.account', (event) ->
    $(@).find(":checkbox").trigger('click')

  $('.accounts .account').css('cursor', 'pointer')

  $('.accounts :checkbox').hide().after('<div class="check-mark" />')

  setSubmit()

