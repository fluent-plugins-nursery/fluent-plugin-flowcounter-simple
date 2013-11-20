# fluent-plugin-flowcounter-simple [![Build Status](https://secure.travis-ci.org/sonots/fluent-plugin-flowcounter-simple.png?branch=master)](http://travis-ci.org/sonots/fluent-plugin-flowcounter-simple)

Simple Fluentd Plugin to count number of messages and outputs to log

## Configuration

    <match foo.bar.**>
      type flowcounter_simple
      unit second
    </source>

This plugin does not emit, just writes into the log file as

    out_flowcounter_simple: 30 / second

## Parameters

- unit

    Either of second/minute/hour/day. Default: minute

## Relatives

There is a [fluent-plugin-flowcounter](https://github.com/tagomoris/fluent-plugin-flowcounter), 
but I needed a very very simple plugin to use for performance evaluation. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2013 Naotoshi Seo. See [LICENSE.txt](LICENSE.txt) for details.

