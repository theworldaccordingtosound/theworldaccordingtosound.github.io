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

SC.initialize(client_id: SC_CLIENT_ID)

players = []

insert_tracks = (playlist_id, element, shared_track) =>
    $element = $(element)
    return if not $element?
    SC.get("/users/162376586/playlists/#{playlist_id}")
        .then ({tracks}) =>
            for track in tracks
                SC_IFRAME_PARAMS.url = SC_PARAM_URL + track.id
                $iframe = $("<iframe></iframe>")
                $iframe.attr(SC_IFRAME_ATTR)
                $iframe.attr('src', SC_URL + $.param(SC_IFRAME_PARAMS))

                $li = $('<li></li>').append($iframe)
                add_share_button($li)
                $element.append($li)

                console.log track.id, shared_track
                start_play = false
                if shared_track == "#{track.id}"
                    start_play = true
                    $('html, body').animate({
                        scrollTop: $iframe.offset().top
                    }, 1000)

                bind_player($iframe, start_play)

bind_player = ($iframe, start_playing) ->
    console.log start_playing
    return if not $iframe[0]?
    player = SC.Widget($iframe[0])
    player.bind(SC.Widget.Events.READY, ->
        player.bind(SC.Widget.Events.FINISH, ->
            episode_finished()
        )

        if start_playing
            console.log 'start'
            player.play()
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

add_share_button = ($element) ->
    $button = $("<div></div>")

    $button.on 'click', =>
        #$('.share_form').css('top')
        $('.share_form').show()

    $button.text('share')
    $button.addClass('share_button')
    $element.append($button)


get_shared_track_id = ->
    window.location.hash?.replace('#','').split('=')?[1]

$ ->
    shared_track = get_shared_track_id()
    console.log shared_track
    insert_tracks('151785242', '.latest', shared_track)
    insert_tracks('153799433', '.featured', shared_track)

    # bind the play all widget
    bind_player($('.home-playall'), false)

    $('#mc-embedded-subscribe').click ->
        # triggers on the popup and the subscribe page
        Cookies.set(SUBCRIBE_LIGHTBOX_COOKIE, 'subscribed')

    $('.share_form .close').on 'click', =>
        $('.share_form').hide()


