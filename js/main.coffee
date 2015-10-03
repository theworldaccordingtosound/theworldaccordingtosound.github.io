---
---

TRACK_IDS = [
    221367374 # mudpots
    221368027 # daisybell
    #221369246 # mimicry
    #221367791 # bridgesongs
]

SC_URL = "https://w.soundcloud.com/player/?"
SC_PARAM_URL = "https://api.soundcloud.com/tracks/"

$ ->

    for track_id in TRACK_IDS
        params =
            url: SC_PARAM_URL + track_id
            color: '0066cc'
            auto_play: false
            hide_related: true
            show_comments: true
            show_user: true
            show_reposts: false

        iframe = $("<iframe></iframe>")
        iframe.attr('width', '100%')
        iframe.attr('height', '166')
        iframe.attr('scrolling', 'no')
        iframe.attr('frameborder', 'no')
        iframe.attr('src', SC_URL + $.param(params))

        $('.post-list').append(
            $('<li></li>').append(iframe)
        )
