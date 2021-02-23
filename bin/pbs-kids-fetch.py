#! /usr/bin/env python
import requests
import sys
import json
import subprocess
import argparse

parser = argparse.ArgumentParser(description='Save PBS Kids shows for later viewing')
parser.add_argument('url', type=str,
                    help='A pbs kids show-list url to fetch shows from', nargs=1)
parser.add_argument('--video-profile', type=str, help='profile of the video stream to download', default='hls-1080p-16x9')
parser.add_argument('--dry-run', action='store_const', const=True, help="fetch info, but don't download videos", default=False)
parser.add_argument('--ffmpeg-path', help="use this executable as ffmpeg", default='ffmpeg')

def main():
    
    args = parser.parse_args()
    print(f"args: {args}")
    url = args.url[0]
    pick_profile = args.video_profile
    dry_run = args.dry_run
    ffmpeg = args.ffmpeg_path
    #url = 'https://producerplayer.services.pbskids.org/show-list/?shows=odd-tube&shows_title=Odd%20Tube&page=1&page_size=20&available=public&sort=-encored_on'

    r = requests.get(url)

    if r.status_code != 200:
        print(f"could not fetch url: {url}, got {r}")
        sys.exit(1)

    j = r.json()

    items = j['items'] 

    for i in items:
        print(f"{i['id']} {i['title']}")

        name = i['id']

        with open(f"{name}.json", "w") as out_json:
            out_json.write(json.dumps(i))

        # pick a video format by the "profle" field. I don't know if this is
        # the best one, but it has 1080p in the name so maybe it's ok

        #pick_profile = 'hls-1080p-16x9'

        vid_url = None
        for v in i['videos']:
            profile = v['profile']
            if profile == pick_profile:
                vid_url = v['url']
                break

        if vid_url is None:
            print(f"could not find video for profile {profile}")

        cmd = [ffmpeg_path, "-f", "hls", "-i", vid_url, "-c", "copy", f"{name}.mkv"]

        if dry_run:
            print(f"would run: {cmd}")
        else:
            subprocess.run(cmd)


if __name__ == "__main__":
    main()


