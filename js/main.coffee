---
---

SC_CLIENT_ID = '75d9afd09a01b26915716ee1590f6c70'

SC_IFRAME_PARAMS =
    color: '0066cc'
    auto_play: false
    hide_related: true
    show_comments: false
    show_user: false
    show_reposts: false
    download: false
    buying: false
    liking: false
    sharing: false
    show_artwork: true
    show_playcount: false

SC_IFRAME_ATTR =
    width: '100%'
    height: 166
    scrolling: 'no'
    frameborder: 'no'

SC_URL = "https://w.soundcloud.com/player/?"
SC_PARAM_URL = "https://api.soundcloud.com/tracks/"

SUBCRIBE_LIGHTBOX_COOKIE = 'slb'

players = []

insert_tracks = (playlist_id, $element) =>
    return unless $element?
    SC.get("/users/162376586/playlists/#{playlist_id}")
        .then ({tracks}) =>
            for {id, description} in tracks
                post_link = description.split('Read more: ')[1]
                insert_single_track($element, id, post_link)

insert_single_track = ($element, track_id, post_link) =>
    return unless $element? and track_id?
    SC_IFRAME_PARAMS.url = SC_PARAM_URL + track_id
    $iframe = $("<iframe></iframe>")
    $iframe.attr(SC_IFRAME_ATTR)
    $iframe.attr('src', SC_URL + $.param(SC_IFRAME_PARAMS))

    $li = $('<li></li>').append($iframe)
    if post_link
        $li.append("<a class='more_link' href='#{post_link}'>Read more</a>")

    $element.append($li)

    bind_player($iframe)

bind_player = ($iframe) ->
    return unless $iframe[0]?
    player = SC.Widget($iframe[0])
    player.bind(SC.Widget.Events.READY, ->
        player.bind(SC.Widget.Events.FINISH, ->
            episode_finished()
        )
    )
    players.push(player)

episode_finished = ->
    if not Cookies.get(SUBCRIBE_LIGHTBOX_COOKIE)?
        for p in players
            p.pause()
        $.featherlight(
            $('#lightbox-content'),
            {beforeClose: before_lightbox_close}
        )

before_lightbox_close = ->
    if not Cookies.get(SUBCRIBE_LIGHTBOX_COOKIE)?
        Cookies.set(SUBCRIBE_LIGHTBOX_COOKIE, 'closed', {expires: 7})
    # to close: $.featherlight.current().close()

$ ->
    # wait for the google fonts to load then render the title
    # we want to avoid FOUT
    font = new FontFaceObserver('Monoton')
    font.load().then (->
        $('.site-title').removeClass('hidden')
    ), ->
        # failed to load the font in 3secs, show the title anyway
        $('.site-title').removeClass('hidden')

    # try to bind various players
    $latest = $('.latest')
    $featured = $('.featured')
    $home_playall = $('.home-playall')
    $post_player = $('.post-player')

    if $latest or $featured or $home_playall or $post_player
        SC.initialize(client_id: SC_CLIENT_ID)

        # homepage playlists
        insert_tracks('151785242', $latest)
        insert_tracks('153799433', $featured)

        # play all widget
        bind_player($home_playall)

        # player on the post pages
        insert_single_track($post_player, $post_player.attr('track'))

    $('#mc-embedded-subscribe').click ->
        # triggers on the popup and the subscribe page
        Cookies.set(SUBCRIBE_LIGHTBOX_COOKIE, 'subscribed')

    # open every link to an external site in a different tab
    $(document.links).filter( ->
        this.hostname != window.location.hostname and this.origin != 'mailto://'
    ).attr('target', '_blank')

    # make whole banner clickabble
    $('.site-banner').click( ->
        window.open('http://www.thelab.org/projects/2016/7/28/the-world-according-to-sound', '_blank')
    )
