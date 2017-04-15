# fluent-plugin-flowcounter-simple, a plugin for [Fluentd](http://fluentd.org) [![Build Status](https://secure.travis-ci.org/sonots/fluent-plugin-flowcounter-simple.png?branch=master)](http://travis-ci.org/sonots/fluent-plugin-flowcounter-simple)

Simple Fluentd Plugin to count number of messages and outputs to log

## Output Plugin Configuration

    <match foo.bar.**>
      type flowcounter_simple
      unit second
    </match>

This plugin does not emit, just writes counts into the log file as

    plugin:out_flowcounter_simple  count:30  indicator:num  unit:second

## Filter Plugin Configuration

Fluentd >= v0.12

```apache
<filter foo.bar.**>
  type flowcounter_simple
  unit second
</filter>
```

This filter plugin pass through records, and writes counts into the log file as

    plugin:out_flowcounter_simple  count:30  indicator:num  unit:second

## Parameters

- unit

    One of second/minute/hour/day. Default: minute

- indicator

    One of num/byte. Default: num

- comment

    Just a comment. You may use this to mark where you put flowcounter_simple.

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

