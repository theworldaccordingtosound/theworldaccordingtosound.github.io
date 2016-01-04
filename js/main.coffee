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
share_link_track = ''

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
                add_share_button($li, track.id)
                $element.append($li)

                bind_player($iframe, (shared_track == track.id))

bind_player = ($iframe, start_play) ->
    return if not $iframe[0]?
    player = SC.Widget($iframe[0])
    player.bind(SC.Widget.Events.READY, ->
        player.bind(SC.Widget.Events.FINISH, ->
            episode_finished()
        )

        if start_play
            $('html, body').animate({
                scrollTop: $iframe.offset().top - 20
            }, 1000)

            if AUTOPLAY
                # iOS doesn't support audio autoplay
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

add_share_button = ($element, track_id) ->
    $button = $("<div></div>")

    $button.on 'click', =>
        if share_link_track == track_id
            share_link_track = ''
            $('.share_form').hide()
        else
            share_link_track = track_id
            full_share_link = window.location.href.split(/[?#]/)[0] + $.query.set("t", track_id)

            {top, left} = $button.offset()
            top = "#{(top - 40)}px"
            right = "#{left}px"

            $('.share_form')
                .css({top, right})
                .show()
                .find('input')
                .val(full_share_link)
                .focus()
                .prop('readonly', true)
                .select()

    $button.text('share')
    $button.addClass('share_button')
    $element.append($button)

$ ->
    shared_track = $.query.get('t')
    insert_tracks('151785242', '.latest', shared_track)
    insert_tracks('153799433', '.featured', shared_track)

    # bind the play all widget
    bind_player($('.home-playall'), false)

    $('#mc-embedded-subscribe').click ->
        # triggers on the popup and the subscribe page
        Cookies.set(SUBCRIBE_LIGHTBOX_COOKIE, 'subscribed')

    $('.share_form .close').on 'click', =>
        share_link_track = ''
        $('.share_form').hide()

