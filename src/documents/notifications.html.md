---
title: "Notifications"
isPage: true
---

Usage:

```
N.wire.emit('notify', params);
N.wire.emit('notify', message_text);
```

Params:

* `type` - _'info'_ or _'error'_ (default).
* `message` - simple string or an HTML.
* `options` controls how message appears. See below
  * `closable` (Boolean, false) adds "close" button when true.
  * `autohide` (Number) Delay in milliseconds before automatically closing a
    notification. Disabled when `false`.

Defaults:

* **info**: `{ closable: false, autohide: 5000 }`
* **error**: `{ closable: true, autohide: 10000 }`


IO Notifications
----------------

We automatically showing notification when error happens during IO communication
(RPC calls):

* on request timeouts, we are showing default error notification
* on server/client versions mismatch, we are showing a permanent
  (non-closable) error notification in the top center position, proposing
  user to reload the page.
* when CSRF token is invalid we are showing default error notification saying
  that CSRF token was updated and that user needs to retry.
* when server returned `{ code: 500 }` we are showing default error notification
  with 'Application Error' message.

