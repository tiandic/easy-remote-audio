# easy-remote-audio
A simple script that allows you to hear the server's sound on the client side on two Linux machines.
## Requirements:
1. server
    - The audio system is PipeWire.
    - Install and start the SSH service.
2. client
    - Install `ssh`, `scp`, `snapserver`, `snapclient` (install command on debian: `sudo apt install snapserver snapclient`)
# Usage:
## help
```bash
$ ./remote_audio.sh   
Example of use:
    ./remote_audio.sh init a@192.168.1.1
Parameter:
init  <user@server>         Initialization, this option must be run before running other options
start <user@server>         Start remote audio
stop                        Stop remote audio
                                              
```
## Example of use:
```bash
git clone https://github.com/tiandic/easy-remote-audio
cd easy-remote-audio
# init will overwrite the server-side ~/.config/pipewire/pipewire.conf.d/my-protocol-simple.conf.
# init may request the server login password multiple times.
# The init only needs to be run the first time this project is run.
./remote_audio.sh init a@192.168.1.1 # Change `a` to the server username and `192.168.1.1` to the server IP.
./remote_audio.sh start a@192.168.1.1
```
At this time, if an audio or video is played on the server, the client will be able to hear the sound.

If you need to stop.

`./remote_audio.sh stop`
