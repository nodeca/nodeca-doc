---
title: "Testing"
isPage: true
order: 180
---

Tests are locatet in `./test` folder, and follow project structure for
convenience:

```
├─ test/
│   ├─ client/ # UI tests
│   ├─ models/ # Unit tests
│   └─ server/ # Integration (RPC) tests
```

Nodeca exposes some global variables & helpers both on server and client
envicoment, to simplify tests writing.

Sources for addons are here: https://github.com/nodeca/nodeca.core/tree/master/lib/test.


## Server env

- `TEST.N`       - `N`.
- `TEST.browser` - patched instance of [Nightmare](http://www.nightmarejs.org/)
  (to write client side tests).

[Nightmare](http://www.nightmarejs.org/) is patched, to use specific nodeca
features.

__Overriden `Nightmare` methods:__

- `.goto(url)`
  - url can be a function
  - wait for client initialization (`NodecaLoader.booted`)
  - install client asserts interceptor
  - set viewport to 1600x1200
- `refresh()`
  - the same additional actions as `.goto()` does.

__Additional `Nightmare` methods:__

- `.evaluateAsync(func, callback [, arg1, arg2...])` - see `evaluate`
   Nightmare's docs for details.
- `.auth(login, callback)`
  - `login` - nickname or User object. Creates user if not exists and login.
     Logout on empty value.
  - `callback(user)` - optional, function to call after success.


### Client env

- `TEST.N`  - `N`
- `assert`  - [Chai](http://chaijs.com/) assert. You can do asert in any part
  of client code. It will be pased to server and processed by testing suite.
- `trigger` - Helper to click selector and listen specific N.wire channel
  to detect operation end. That's more convenient and effective, than use
  Nightmare's `.wait()`.
