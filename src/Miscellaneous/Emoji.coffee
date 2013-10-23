Emoji =
  init: ->
    return unless Conf['Emoji']

    pos = Conf['emojiPos']
    css = ["""
a.useremail[href]:last-of-type::#{pos} {
  vertical-align: top;
  margin-#{if pos is "before" then "right" else "left"}: 5px;
}\n
  """]

    @icons["PlanNine"] = Emoji.icons["Plan9"]
    @icons['Sage']     = Emoji.sage[Conf['sageEmoji']]

    for name, icon of @icons
      continue unless @icons.hasOwnProperty name
      css.push """
a.useremail[href*='#{name}']:last-of-type::#{pos},
a.useremail[href*='#{name.toLowerCase()}']:last-of-type::#{pos},
a.useremail[href*='#{name.toUpperCase()}']:last-of-type::#{pos} {
  content: url('data:image/png;base64,#{icon}');
}\n
"""

    $.addStyle css.join(""), 'emoji'

  sage:
    '4chan SS': '<%= grunt.file.read("src/General/img/emoji/SS-sage.png",      {encoding: "base64"}) %>'
    'appchan':  '<%= grunt.file.read("src/General/img/emoji/appchan-sage.png", {encoding: "base64"}) %>'

  icons:
    'Plan9':      '<%= grunt.file.read("src/General/img/emoji/plan9.png",      {encoding: "base64"}) %>'
    'Neko':       '<%= grunt.file.read("src/General/img/emoji/neko.png",       {encoding: "base64"}) %>'
    'Madotsuki':  '<%= grunt.file.read("src/General/img/emoji/madotsuki.png",  {encoding: "base64"}) %>'
    'Sega':       '<%= grunt.file.read("src/General/img/emoji/sega.png",       {encoding: "base64"}) %>'
    'Sakamoto':   '<%= grunt.file.read("src/General/img/emoji/sakamoto.png",   {encoding: "base64"}) %>'
    'Baka':       '<%= grunt.file.read("src/General/img/emoji/baka.png",       {encoding: "base64"}) %>'
    'Ponyo':      '<%= grunt.file.read("src/General/img/emoji/ponyo.png",      {encoding: "base64"}) %>'
    'Rabite':     '<%= grunt.file.read("src/General/img/emoji/rabite.png",     {encoding: "base64"}) %>'
    'Arch':       '<%= grunt.file.read("src/General/img/emoji/arch.png",       {encoding: "base64"}) %>'
    'CentOS':     '<%= grunt.file.read("src/General/img/emoji/centos.png",     {encoding: "base64"}) %>'
    'Debian':     '<%= grunt.file.read("src/General/img/emoji/debian.png",     {encoding: "base64"}) %>'
    'Elementary': '<%= grunt.file.read("src/General/img/emoji/elementary.png", {encoding: "base64"}) %>'
    'Fedora':     '<%= grunt.file.read("src/General/img/emoji/fedora.png",     {encoding: "base64"}) %>'
    'FreeBSD':    '<%= grunt.file.read("src/General/img/emoji/freebsd.png",    {encoding: "base64"}) %>'
    'Gentoo':     '<%= grunt.file.read("src/General/img/emoji/gentoo.png",     {encoding: "base64"}) %>'
    'Mint':       '<%= grunt.file.read("src/General/img/emoji/mint.png",       {encoding: "base64"}) %>'
    'Osx':        '<%= grunt.file.read("src/General/img/emoji/osx.png",        {encoding: "base64"}) %>'
    'Rhel':       '<%= grunt.file.read("src/General/img/emoji/rhel.png",       {encoding: "base64"}) %>'
    'Sabayon':    '<%= grunt.file.read("src/General/img/emoji/sabayon.png",    {encoding: "base64"}) %>'
    'Slackware':  '<%= grunt.file.read("src/General/img/emoji/slackware.png",  {encoding: "base64"}) %>'
    'Trisquel':   '<%= grunt.file.read("src/General/img/emoji/trisquel.png",   {encoding: "base64"}) %>'
    'Ubuntu':     '<%= grunt.file.read("src/General/img/emoji/ubuntu.png",     {encoding: "base64"}) %>'
    'Windows':    '<%= grunt.file.read("src/General/img/emoji/windows.png",    {encoding: "base64"}) %>'
    'OpenBSD':    '<%= grunt.file.read("src/General/img/emoji/openbsd.png",    {encoding: "base64"}) %>'
    'Gnu':        '<%= grunt.file.read("src/General/img/emoji/gnu.png",        {encoding: "base64"}) %>'
    'CrunchBang': '<%= grunt.file.read("src/General/img/emoji/crunchbang.png", {encoding: "base64"}) %>'
    'Yuno':       '<%= grunt.file.read("src/General/img/emoji/yuno.png",       {encoding: "base64"}) %>'
