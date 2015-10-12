# LoadBox
## A Downloader Toolset for Unix-Based Systems

LoadBox is a reliable download toolset for headless and embedded unix-based systems like Raspberry Pi, Beaglebone or Virtual boxes.


This toolset is designed with some particular situations in mind. Please DO NOT use it on a PC system.

It has numerous features including Torrents support, Local Network Storages, Network Push, Flash Disk Hotplugging, Protected Web Interface with HTTPS and Authentication and Download Resume support even in case of accidental power loss or disk unplug.

**TODO:** Documentation! There's a lot to tell.

Please note, Use it only on isolated environments like virtual boxes or development boards for testing. Although, it's not expected to observe aggresive behaviors.

## Usage
**Note:** Remember, It's a work in progress. Read above paragraphs if you skipped.

As a quick start,

    $ sudo apt-get install aria2c

Clone the repo to a directory like `~/LoadBox/`:

    $ git clone https://github.com/zxcmehran/LoadBox
    $ cd LoadBox
    $ git submodule init
    $ git submodule update --depth 1

Then, add the following to `/etc/rc.local` file:

    /home/user/LoadBox/startup.sh

Edit `aria2.conf`, `configuration.sh`, `scripts/configuration.py` and `webui/configuration.js` files to suit you best.

To schedule commands, update crontab file using `sudo crontab -e` and enter following at the end of the file. It will limit download speed at 10:00AM and remove limitations after midnight at 2:30AM.

    30 02 * * * /home/[username]/LoadBox/scripts/unlimitdownloads.py
    00 10 * * * /home/[username]/LoadBox/scripts/limitdownloads.py

And you can use these scripts to start/stop all download jobs:

    /home/[username]/LoadBox/scripts/startdownloads.py
    /home/[username]/LoadBox/scripts/stopdownloads.py

It's tested on Raspbian Jessie. Some features like `rpc_secret` cannot be used on Raspbian Wheezy because of outdated `aria2` package. Versions prior `1.18.1` have a bug which cause problems with RPC secret functionality. You might want to compile a recent version of `aria2`.

It's better *not* to boot directly to GUI. Booting to CLI helps you to save CPU/RAM and see console log to debug system in case of problems.

##License
[MIT (Expat)](https://www.tldrlegal.com/l/mit) License
