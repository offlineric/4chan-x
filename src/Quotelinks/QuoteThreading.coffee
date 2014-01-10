###
  <3 aeosynth
###

QuoteThreading =
  init: ->
    return unless Conf['Quote Threading'] and g.VIEW is 'thread'

    @enabled = true
    @controls = $.el 'span',
      innerHTML: '<label><input id=threadingControl type=checkbox checked> Threading</label>'

    input = $ 'input', @controls
    $.on input, 'change', @toggle

    $.event 'AddMenuEntry',
      type:  'header'
      el:    @controls
      order: 98

    $.on d, '4chanXInitFinished', @setup unless Conf['Unread Count']

    Post.callbacks.push
      name: 'Quote Threading'
      cb:   @node

  setup: ->
    $.off d, '4chanXInitFinished', QuoteThreading.setup
    QuoteThreading.force()

  force: ->
    post.cb true for ID, post of g.posts when post.cb
    return

  node: ->
    {posts} = g
    return if @isClone or not QuoteThreading.enabled
    Unread.posts.push @ if Conf['Unread Count']

    return if @thread.OP is @ or !(post = posts[@fullID]) or post.isHidden # Filtered

    keys = []
    len = g.BOARD.ID.length + 1
    keys.push quote for quote in @quotes when (quote[len..] < @ID) and quote of posts

    return unless keys.length is 1

    @threaded = keys[0]
    @cb       = QuoteThreading.nodeinsert

  nodeinsert: (force) ->
    post = g.posts[@threaded]

    return false if @thread.OP is post

    {posts} = Unread
    {root}  = post.nodes

    unless force
      height  = doc.clientHeight
      {bottom, top} = root.getBoundingClientRect()

      # Post is unread or is fully visible.
      return false unless (Conf['Unread Count'] and posts[post.ID]) or ((bottom < height) and (top > 0))

    if $.hasClass root, 'threadOP'
      threadContainer = root.nextElementSibling
      post = Get.postFromRoot $.x 'descendant::div[contains(@class,"postContainer")][last()]', threadContainer
      $.add threadContainer, @nodes.root

    else
      threadContainer = $.el 'div',
        className: 'threadContainer'
      $.add threadContainer, @nodes.root
      $.after root, threadContainer
      $.addClass root, 'threadOP'

    return true unless Conf['Unread Count']

    if posts[post.ID]
      posts.after post, @

    else
      posts.prepend @

    return true

  toggle: ->
    if QuoteThreading.enabled = @checked
      QuoteThreading.force()

    else
      thread = $('.thread')
      posts = []
      nodes = []

      posts.push post for ID, post of g.posts when not (post is post.thread.OP or post.isClone)
      posts.sort (a, b) -> a.ID - b.ID

      nodes.push post.nodes.root for post in posts
      $.add thread, nodes

      containers = $$ '.threadContainer', thread
      $.rm container for container in containers
      $.rmClass post, 'threadOP' for post in $$ '.threadOP'
    
    return

  kb: ->
    control = $.id 'threadingControl'
    control.checked = not control.checked
    QuoteThreading.toggle.call control