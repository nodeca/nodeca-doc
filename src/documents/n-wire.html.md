---
title: "N.wire (message bus)"
isPage: true
order: 70
---

The special object
[N.wire](https://github.com/nodeca/nodeca.core/blob/master/lib/system/wire.js),
that combine features of 'mediator' AND 'chain of responsibility'. You can
consider it as pool of chains, or as mediator with weighted subscribers.

**NOTE** We consider handler with zero priority as "main". Others are considered
as before/after filters (can be extended via hooks). 

Known channels:

``` none
init:models          - load models. (!) db connections established on 'before' filters
init:stores          - load stores (probably, have to move on 'after' filter)
init:migrations      - check migrations
init:bundle          - load server methods, i18n, client, ... and create bundles
init:server          - start server listener
server:**            - http/rpc responders & hooks attached there
server:core.static   - micro static server for robots.txt and others
server:core.assets   - assets server
```

Typical hooks list:

``` none
[-99] puncher_start
[-85] cookies_start
[-80] session_start
[-75] csrf_protect
[-65] locale_inject
[-10] load_current_user
[0] <anonymous>
[10] join_users
[50] inject_menu
[50] init_recaptcha
[50] inject_assets_info
[85] renderer
[90] cookies_end    !permanent
[90] session_end    !permanent
[99] puncher_end
```


Dev tools (server)
------------------

CLI allows to dump existing chains:

``` bash
$ ./nodeca.js filters                   # show all chains & all handlers
$ ./nodeca.js filters -h                # show help
$ ./nodeca.js filters -s                # show all chains, without details
$ ./nodeca.js filters -m server:core.   # show server:core.* chains & handlers
```


Wire API
--------

See [Wire source code](https://github.com/nodeca/nodeca.core/blob/master/lib/system/wire.js)
for details.


### Wire.emit(channel, params, [callback])

Sends message with `params` into the `channel`. Once all sync and ascync
handlers finished, optional `callback(err)` (if specified) fired.

On multiple channels (when channel is Array of strings), all chanins are
executed in serial. See examples in `./cli` sources.

Chain can be terminated, if handler returns error (in callback or in result).
But some handlers can have flags 'non terminateable' - that can be useful
to finalize session deals.


### Wire.on(channel, [options], handler)

Registers `handler` (sync or async) to be executed upon messages in the
`channel`. Glob patterns are allowed (** and *)

Options:

- `priority` (Default: 0)
- `ensure` (Default: false) -  if `true`, will run handler even
   if one of previous fired error.


### Wire.before, Wire.after

Shugar of `Wire.on`. But with default priority -10 and +10.


### Wire.once

The same as `Wire.on`, but subscriber automatically removed after fire.


### Wire.off(channel[, handler])

Unsubscribe handler (or all) from channel


### Wire.skip(channel, skipList)

Disable named handler(s) on specified channel. For example, you can wish to
disable session & cookies handlers on static server responder.


### Wire.has(channel)

Returns if `channel` has at least one subscriber with zero priority. Used
by router, to check if server method exits. Filters can be added by externals
applications, but we should not use chain without "main" method.


### Wire.stat()

Wire statistics (channels, handlers, counters).
