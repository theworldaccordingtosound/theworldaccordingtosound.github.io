#!/usr/bin/env python
import soundcloud
import os.path

# encoding weirdness: http://stackoverflow.com/questions/2276200/changing-default-encoding-of-python
import sys
reload(sys)  # Reload does the trick!
sys.setdefaultencoding('UTF8')

client = soundcloud.Client(client_id='75d9afd09a01b26915716ee1590f6c70')
playlist = client.get('/playlists/139584151')

for track in playlist.tracks:
    title = track['title'].encode("utf-8")
    spl = title.split("\xe2")
    if not len(spl) == 2:
      spl = title.split('-')

    date = track['last_modified'].encode("utf-8").split(" ")[0].replace("/", "-")

    output = ["---",
              "layout: post",
              "title: 'Episode {}'".format(track['title']),
              "date: {}".format(date),
              "published: true",
              "track_id: {}".format(track['id']),
              "---",
              "<div class='list post-player' track='{{page.track_id}}'></div>",
             ]
    postnum = spl[0].split(',')[0].strip()
    postname = spl[1].split(" ")[-1]
    filename = "../_posts/" + date + "_" + postnum + "_" + postname + ".md"
    filename = filename.lower()
    if not os.path.isfile(filename) :
      with open(filename, "w") as f:
        f.write("\n".join(output))

