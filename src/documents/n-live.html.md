---
title: "N.live (realtime)"
isPage: true
order: 75
---

Used to:

- get instant server messages (notifications about updates)
- store small user data without creating new requests every time
  (scroll positions, activities and so on).


Methods
-------

- `N.live.emit(channel, data)` - sends data into the `channel`
- `N.live.debounce(channel, data)` - __server only__. Filer messages via debouncer (3 sec) and send then
- `N.live.on(channel, handler)` - registers `handler` to be executed upon messages in the `channel`
- `N.live.off(channel [, handler])` - unsubscribe handler (or all) from channel


Namespaces
----------

Client side specific things:

- `local.*` - messages will go to local tabs only, and will not pass to server at all.
- `private.*` - our internal conventions, for convenience. All posting should be
   done only here.


Server extensions
-----------------

Every incoming message (subscribe/post) from client is forwarded to internal
methods.

- `internal.live.subscribe:{channel.name}` - check subscribe permission
- `internal.live.post:{channel.name}` - to handle message from client

Current files location:

```none
.
└─ internal/
    └─ <namespace>/
        └─ live/
            ├─ post/*.js
            └─ subscribe/*.js
```

Code example:

```javascript
N.wire.on('internal.live.subscribe:forum.topic.*', function (data, callback) {
  // check permission...
  data.allowed = true;
  callback();
});
```

Data object:

- __allowed__ (Boolean) - `false` by default, server handler should check
  permission and set to `true`
- __message__ (Object)
  - __data__ (Object) - data received from client
- __channel__ (String) - channel name
- __getSession__ (Function) - `function (err, session)`,
  [session loader helper](https://github.com/nodeca/nodeca.core/blob/pos/internal/common/live/session.js)


Channels examples
-----------------

- `private.core.marker.set_scroll` - set scroll position in topic and etc.
- `forum.topic.{topic_hid}` - topic updates
- `forum.section.{section_hid}` - section updates
