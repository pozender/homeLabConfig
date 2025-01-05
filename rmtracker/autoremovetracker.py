import qbittorrentapi
import time
import os

host = str(os.getenv('HOST')) or '192.168.1.167'
port = '8080'
username = str(os.getenv('USER'))
password = str(os.getenv('PASSWD'))

qbt_client = qbittorrentapi.Client(host=host, port=port, username=username, password=password)

try:
    qbt_client.auth_log_in()
except qbittorrentapi.LoginFailed as e:
    print(e)

def mainFunc():
    def removerTracker():
        torrents = qbt_client.torrents.info.downloading()
        if torrents:
            time.sleep(0.7)
            for torrent in torrents:
                    trackers= [torrent for torrent in torrent.trackers ]
                    url=[]
                    for tracker in trackers:
                        for link in tracker:
                            if link == 'url':
                                url.append(tracker[link])
                    if len(url)>3:
                          try:
                            qbt_client.torrents_remove_trackers(torrent_hash=torrent.info.hash, urls=url)
                            print("Well done Soldier")
                          except Exception as e:
                            print(f"Error removing trackers: {e}")
    try:
        removerTracker()
    except Exception as e:
        print(f"Error in removerTracker: {e}")

if __name__ == '__main__':
    while True:
        try:
            mainFunc()
        except Exception as e:
            print(f"Error in mainFunc: {e}")
        time.sleep(10)
