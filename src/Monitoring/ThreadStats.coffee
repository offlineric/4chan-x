ThreadStats =
  init: ->
    return if g.VIEW isnt 'thread' or !Conf['Thread Stats']

    if Conf['Updater and Stats in Header']
      @dialog = sc = $.el 'span',
        innerHTML: "<span id=post-count>0</span> / <span id=file-count>0</span>#{if Conf["Page Count in Stats"] then " / <span id=page-count>0</span>" else ""}"
        id:        'thread-stats'
        title: 'Post Count / File Count' + (if Conf["Page Count in Stats"] then " / Page Count" else "")
      $.ready ->
        Header.addShortcut sc
    else 
      @dialog = sc = UI.dialog 'thread-stats', 'bottom: 0px; right: 0px;',
        "<div class=move title='Post Count / File Count#{if Conf["Page Count in Stats"] then " / Page Count" else ""}'><span id=post-count>0</span> / <span id=file-count>0</span>#{if Conf["Page Count in Stats"] then " / <span id=page-count>0</span>" else ""}</div>"
      $.ready => 
        $.add d.body, sc    

    @postCountEl = $ '#post-count', sc
    @fileCountEl = $ '#file-count', sc
    @pageCountEl  = $ '#page-count', sc

    Thread.callbacks.push
      name: 'Thread Stats'
      cb:   @node

  node: ->
    postCount = 0
    fileCount = 0
    for ID, post of @posts
      postCount++
      fileCount++ if post.file
    ThreadStats.thread = @
    ThreadStats.fetchPage()
    ThreadStats.update postCount, fileCount
    $.on d, 'ThreadUpdate', ThreadStats.onUpdate

  onUpdate: (e) ->
    return if e.detail[404]
    {postCount, fileCount} = e.detail
    ThreadStats.update postCount, fileCount

  update: (postCount, fileCount) ->
    {thread, postCountEl, fileCountEl} = ThreadStats
    postCountEl.textContent = postCount
    fileCountEl.textContent = fileCount
    (if thread.postLimit and !thread.isSticky then $.addClass else $.rmClass) postCountEl, 'warning'
    (if thread.fileLimit and !thread.isSticky then $.addClass else $.rmClass) fileCountEl, 'warning'

  fetchPage: ->
    return if !Conf["Page Count in Stats"]
    if ThreadStats.thread.isDead 
      ThreadStats.pageCountEl.textContent = 'Dead'
      $.addClass ThreadStats.pageCountEl, 'warning'
      return
    setTimeout ThreadStats.fetchPage, 2 * $.MINUTE
    $.ajax "//api.4chan.org/#{ThreadStats.thread.board}/threads.json", onload: ThreadStats.onThreadsLoad,
      whenModified: true

  onThreadsLoad: ->
    return unless Conf["Page Count in Stats"] and @status is 200
    pages = JSON.parse @response
    for page in pages
      for thread in page.threads
        if thread.no is ThreadStats.thread.ID
          ThreadStats.pageCountEl.textContent = page.page
          (if page.page is pages.length - 1 then $.addClass else $.rmClass) ThreadStats.pageCountEl, 'warning'
          return
