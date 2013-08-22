IDColor =
  init: ->
    return if g.VIEW is 'catalog' or !Conf['Color user IDs']
    @ids = {}

    Post::callbacks.push
      name: 'Color user IDs'
      cb:   @node

  node: ->
    return if @isClone or !(uid = @info.uniqueID)
    rgb = IDColor.compute uid
    span = @nodes.uniqueID
    {style} = span
    style.color = rgb[3]
    style.backgroundColor = "rgb(#{rgb[0]},#{rgb[1]},#{rgb[2]})"
    $.addClass span, 'painted'
    span.textContent = uid
    span.title = 'Highlight posts by this ID'

  compute: (uniqueID) ->
    if uniqueID of IDColor.ids
      return IDColor.ids[uniqueID]
    hash = @hash uniqueID
    rgb = [
      (hash >> 24) & 0xFF
      (hash >> 16) & 0xFF
      (hash >> 8)  & 0xFF
    ]
    rgb.push if (rgb[0] * 0.299 + rgb[1] * 0.587 + rgb[2] * 0.114) > 125
      'black'
    else
      'white'
    @ids[uniqueID] = rgb

  hash: (uniqueID) ->
    msg = 0
    for i in [0...uniqueID.length]
      msg = (msg << 5) - msg + uniqueID.charCodeAt i
    msg
