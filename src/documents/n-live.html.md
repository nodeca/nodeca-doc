---
title: "N.live (instant messaging)"
isPage: true
order: 70
---

Methods
-------

- `N.live.emit(channel, data)` - sends data into the `channel`
- `N.live.on(channel, handler)` - registers `handler` to be executed upon messages in the `channel`
- `N.live.off(channel [, handler])` - unsubscribe handler (or all) from channel

Namespaces
----------

- `local.*` - used to communicate between tabs without server
- `private.*` - post data to server without broadcast

Server extensions
-----------------

To extend actions (subscribe and post):

- `internal.live.subscribe:{channel.name}` - to check subscribe permission 
- `internal.live.post:{channel.name}` - to handle message from client

```none
.
└─ internal/
    └─ <namespace>/
        └─ live/
            ├─ post/*.js
            └─ subscribe/*.js
```

```javascript
  N.wire.on('internal.live.subscribe:users.private.*', function (data, callback) {
    // check permission...
    data.allowed = true;
    callback();
  });
```

Data object:

- __allowed__ (Boolean) - `false` by default, server handler should check permission and set to `true`
- __message__ (Object)
  - __data__ (Object) - data received from client
- __channel__ (String) - channel name
- __getSession__ (Function) - `function (err, session)`,
  [session loader helper](https://github.com/nodeca/nodeca.core/blob/pos/internal/common/live/session.js)

Channels example
----------------

- `private.core.marker.set_scroll` - set scroll position in topic and etc.
- `forum.topic.{topic_hid}` - topic updates
- `forum.section.{section_hid}` - section updates
