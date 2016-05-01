#!/usr/bin/env python

from os import listdir
from os.path import isfile, join
import re

PATH="../_posts/"

files = [f for f in listdir(PATH) if isfile(join(PATH, f))]

for filename in files:
  with open(PATH + filename, "r") as f:
    lines = f.readlines()

  # Find the episode number
  episode_num = None
  for idx, line in enumerate(lines):
    if line.strip().lower().startswith("title: "):
      episode_num = re.split(" |'|:|\"|,", line)[4]
      title_line_num = idx
      break

  if episode_num is None:
    print("Episode number not found in file '{}' !".format(filename))
    continue

  #episode_line = "episode: {}\n".format(episode_num.zfill(4))
  episode_line = "episode: {}\n".format(episode_num)
  old_episode_line = None
  for idx, line in enumerate(lines):
    if line.strip().lower().startswith("episode: "):
      old_episode_line = line
      old_episode_line_num = idx
      print("episode line found")
      break

  if old_episode_line is None:
    print("episode line NOT found")
    lines.insert(title_line_num, episode_line)
  else:
    lines[old_episode_line_num] = episode_line

  # remove the 'date:' line
  for idx, line in enumerate(lines):
    if line.strip().lower().startswith("date: "):
      lines.pop(idx)
      break

  with open(PATH + filename, "w") as f:
    f.write("".join(lines))



