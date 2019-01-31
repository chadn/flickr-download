# Introduction

[![Build Status](https://travis-ci.org/beaufour/flickr-download.svg)](https://travis-ci.org/beaufour/flickr-download)

Simple script to download a [Flickr](http://flickr.com) set.

To use it you need to get your own Flickr API key here:
https://www.flickr.com/services/api/misc.api_keys.html

    flickr_download -k <api key> -s <api secret> -d <set id>

It can also list the public set ids for a given user:

    flickr_download -k <api key> -s <api secret> -l <user name>

Get a public set using the title and id to name the downloaded files:

    flickr_download -k <api key> -s <api secret> -d <set id> -n title_and_id

Download private or restricted photos by authorising against the users account. (see below)

# Installation

To install this script use the Python pip utility bundled with your Python distribution:

    pip install flickr_download

# API key

Get your [Flickr API key](http://www.flickr.com/services/api/).

You can also set your API key and secret in `~/.flickr_download`:

    api_key: my_key
    api_secret: my_secret

# User Authentication Support

The script also allows you to authenticate as a user account. That way you can download sets that
are private and public photos that are restricted. To use this mode, initialise the authorisation by
running the script with the `t` parameter to authorize the app.

    flickr_download -k <api key> -s <api secret> -t

This will save `.flickr_token` containing the authorisation. Subsequent calls with `-t` will use the
stored token. For example using

    flickr_download -k <api key> -s <api secret> -l <USER>

with _USER_ set to your own username, will only fetch your publicly available sets, whereas adding `-t`

    flickr_download -k <api key> -s <api secret> -l <USER> -t

will fetch all your sets including private restricted sets.

# Requirements

* [argparse](http://docs.python.org/2.7/library/argparse.html) (Python 2.7+)
* [Python Dateutil](http://labix.org/python-dateutil)
* [Python Flickr API](https://github.com/alexis-mignon/python-flickr-api/)
* [PyYAML](http://pyyaml.org/)

# Usage and Optional Arguments

```
usage: flick_download.py [-h] [-k API_KEY] [-s API_SECRET] [-t] [-l USER]
                         [-d SET_ID] [-p USERNAME]
                         [--download_user_photo_list USERNAME]
                         [--photo_list_file PHOTO_LIST_FILE] [-u USERNAME]
                         [-i PHOTO_ID] [-q SIZE_LABEL] [-n NAMING_MODE] [-m]
                         [-o] [-j] [--content_dir CONTENT_DIR] [--debug]

Downloads one or more Flickr photo sets.

To use it you need to get your own Flickr API key here:
https://www.flickr.com/services/api/misc.api_keys.html

For more information see:
https://github.com/beaufour/flickr-download

You can store argument defaults in ~/.flickr_download. API keys for example:
  api_key: .....
  api_secret: ...

optional arguments:
  -h, --help            show this help message and exit
  -k API_KEY, --api_key API_KEY
                        Flickr API key
  -s API_SECRET, --api_secret API_SECRET
                        Flickr API secret
  -t, --user_auth       Enable user authentication
  -l USER, --list USER  List photosets for a user
  -d SET_ID, --download SET_ID
                        Download the given set
  -p USERNAME, --download_user_photos USERNAME
                        Download all photos for a given user
  --download_user_photo_list USERNAME
                        Download just list of all photos for a given user
  --photo_list_file PHOTO_LIST_FILE
                        file containing photo ids to download, one id per line
  -u USERNAME, --download_user USERNAME
                        Download all sets for a given user
  -i PHOTO_ID, --download_photo PHOTO_ID
                        Download one specific photo
  -q SIZE_LABEL, --quality SIZE_LABEL
                        Quality of the picture
  -n NAMING_MODE, --naming NAMING_MODE
                        Photo naming mode
  -m, --list_naming     List naming modes
  -o, --skip_download   Skip the actual download of the photo
  -j, --save_json       Save sets or photo info like description and tags, one .json file per photo
  --content_dir CONTENT_DIR
                        directory where all content exists, for reading and writing files
  --debug               Output debug info on progress, etc.

examples:
  list all sets for a user:
  > flickr_download/flick_download.py -k <api_key> -s <api_secret> -l beaufour

  download a given set:
  > flickr_download/flick_download.py -k <api_key> -s <api_secret> -d 72157622764287329

  download a given set, keeping duplicate names:
  > flickr_download/flick_download.py -k <api_key> -s <api_secret> -d 72157622764287329 -n title_increment
```

# Handle Users with Thousands of Photos 

Created a bash script, runme.sh, which will keep calling python until all photos are downloaded from flickr.
This file is meant to be edited and inspected, works on OSX and linux, not tested on windows.

Some of the many things this does is
* Creates a log file with timestamped entries of progress.  Makes it easy to start as a background process, `runme.sh &`, and then just view the log file for progress
* You can specify directory to save all photos and photo meta data as json.

