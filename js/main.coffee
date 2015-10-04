---
---

TRACK_IDS = [
    221367374 # mudpots
    221368027 # daisybell
    #221369246 # mimicry
    #221367791 # bridgesongs
]

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
    sharing: true
    show_artwork: true
    show_playcount: false

SC_IFRAME_ATTR =
    width: '100%'
    height: 166
    scrolling: 'no'
    frameborder: 'no'

SC_URL = "https://w.soundcloud.com/player/?"
SC_PARAM_URL = "https://api.soundcloud.com/tracks/"

$ ->
    for track_id in TRACK_IDS
        SC_IFRAME_PARAMS.url = SC_PARAM_URL + track_id
        iframe = $("<iframe></iframe>")
        iframe.attr(SC_IFRAME_ATTR)
        iframe.attr('src', SC_URL + $.param(SC_IFRAME_PARAMS))

        $('.post-list').append(
            $('<li></li>').append(iframe)
        )
