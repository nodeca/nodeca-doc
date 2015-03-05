---
title: "Testing"
isPage: true
---

```
├─ test/
│   ├─ client/ # UI tests
│   ├─ models/ # Unit tests
│   └─ server/ # Integration (RPC) tests
```


UI tests
--------

### Server-side

- `TEST.N`       - Exposed N
- `TEST.browser` - [Nightmare](http://www.nightmarejs.org/) instance

For UI testing we use extended [Nightmare](http://www.nightmarejs.org/).

Overridden methods:

- `goto(url)`
  - url can be a function
  - wait for client initialization (`NodecaLoader.booted`)
  - setup testing environment
- `refresh()`
  - wait for client initialization (`NodecaLoader.booted`)
  - setup testing environment

Added methods:

- `evaluateAsync(func, callback/**, arg1, arg2...*/)` - see `evaluate` in Nightmare's docs for details
- `auth(login, callback)`
  - `login` - if empty - do logout, if exists - login, if not exists - create user and login
  - `callback(user)` - optional


### Client-side

- `TEST.N`  - Exposed N
- `trigger` - Do click by element and wait for finish
- `assert`  - [Chai](http://chaijs.com/) assert
