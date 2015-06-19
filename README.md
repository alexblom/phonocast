# Cassette

Cassette is a gem to convert local audio files to a podcast feed, which
can then be deployed on your own server or even Dropbox.

*Motivation:*
[http://dancarlin.com/product/hardcore-history-compilation-episodes-1-39](http://dancarlin.com/product/hardcore-history-compilation-episodes-1-39) with [https://overcast.fm](https://overcast.fm)'s 2x speed.

## Installation

gem install #TODO

## Usage

### Generating an RSS Feed:

``
cassette create_feed
``

### Setup Yaml Config

Instead of passing the same arguments to the CLI each time, you can
store them ina  YAML file. The YAML file also provides configuration
options not available by the CLI.

To generate the YAML file:
``
cassette setup
``

## Feed Config Options.

Options can be set by YAML or CLI arguments. The order of
precedence is:

DEFAULTS -> YAML -> CLI Arguments.

So if you have YAML.title = "Title 1" and CLI.title = "Title 2", the
title used will be "Title 2". Generally speaking, store your config in YAML and use CLI arguments for
one off overrides.

All itunes\_ tags correspond to iTunes RSS spec.

| Name            | CLI | YAML |  Desc            |
| -------------   | --- | ---- | ---------------- |
| base_url        | Y   | Y    | Url where audio files are hosted, e.g. myserver.com/podcasts or mypublicdropbox.com. Defaults to link. |
| target          | Y   | Y    | Location and name of generated rss file. Default: ./cassette.rss |
| file_path       | Y   | Y    | Where are local audio files? Default: ./ |
| title           | Y   | Y    | Title of Podcast |
| link            | Y   | Y    | Channel level link (e.g. mypodcast.com) |
| yaml_path       | Y   | Y    | Location of YAML file for config. Default: ./cassette.yaml |
| copyright       | N   | Y    | Channel level |
| language        | N   | Y    | Channel level |
| description     | N   | Y    | Channel level |
| author          | N   | Y    | Channel level |
| itunes_block    | N   | Y    | Channel level |
| itunes_explicit | N   | Y    | Channel level |
| itunes_keywords | N   | Y    | Channel level |
| itunes_image    | N   | Y    | Channel level |
| itunes_subtitle | N   | Y    | Defaults to description. |
| itunes_summary  | N   | Y    | Defaults to description. |

TODO - target_rss not implemented

## Deployment

### Private Server:
``
scp -r . server:/path
``

### Dropbox:
Drag and drop to Dropbox Public folder and set base_url appropriately.

## Contributing

Contributions welcome. Please open pull requests and include tests.

Need contribution ideas?

``
grep -rni todo lib/
``

## Copyright

Copyright (c) 2015 Alex Blom. See LICENSE for further details.

