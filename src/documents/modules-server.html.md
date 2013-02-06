---
title: "Modules - Server"
isPage: true
order: 90
---

Files `./server/**/*.js` are loaded & initialized as server responders.

``` none
├─ server/
│   └─ admin/
│       ├─ dashboard.js
│       └─ users.js
```

Module shoud export 1 method, that add all nesessary validators & listeners
to provided channel. 'Channel name' is calculated from FS path + `server:` prefix.

Example for dummy dashboard.js:

``` javascript
module.exports = function (N, apiPath) {

  // N - application sandbox
  // apipath - server:admin.dashboard

  // Dummy validator
  N.validate(apiPath, {});

  // we can skip callback for synk handler
  N.wire.on(apiPath, function (env, callback) {
    env.response.data.now = (new Date).toString();
    callback();
  });
};
```

**NOTE** `server:` prefix is reserved for server responders. You can be sure,
that all events will pass `env` (enviroment) as listenner params.


Request Environment (env)
-------------------------

All requests are executed within separate context, with `env` structure
available:

``` none
env                     # `this` context of actions/filters

  method                # called method name (e.g.: ‘forum.posts.show’)
  params                # request params

  data                  # raw data from models

  err                   # internal, to pass error on finalization in responder
  log                   # internal, low-level logger for responders
  body                  # internal, used in responder end to prepare reply

  headers               # http headers sandbox. (!) don't use `res` directly
  
  ?settings              # optional sandbox for settings (permissions) fetch
    params              # required for fetch
    fetch()             #

  origin                # low-level data, rarely used, mostly to determine request type
    req                 # real server request and server response objects.
    res                 #

  session               # session data
    session_id
    csrf
    user_id
    locale
    theme

  request               # request details
    namespace           # called method namespace (e.g.: `forum`)
    ip                  # request ip
    user_agent          # browser/user agent
    type                # responder type (http/rpc)

  response              # Response sandbox
    data                # output data (for json or renderer)
                        #     Default: `{widgets: {}}`
    layout              # (Optional) ‘default’ if not set
    view                # (Optional) request.method if not set

  helpers               # helpers added by filters and available in views
    t()                 # babelfish.t proxy, without `language` param

  extras                # shared storage for data (used for helpers)
    puncher()
    setCookies()

  runtime               # data, injected into http page
    layout
    csrf
```

**NOTE**. `env` should avoid functions, to be transparent for
server-server communications. But we have exclusion for `static` helpers


Hooks
-----

Data processing can be extended by adding channel listeners. They sequentially
modify `env` object, according to priorities. See
[source code](https://github.com/nodeca/nodeca.core/tree/master/lib/hooks/requests)
of existing extentions.


Validating request params
-------------------------

All server methods, must define params validation schema. If validation
rule missed - all calls will be rejected with errors.
See [JSON Schema](http://json-schema.org/) specifications. We support
basic subset, described in [revalidator](https://github.com/flatiron/revalidator)
docs.

Example:

``` javascript
N.validate(apiPath, {
  // forum id
  id: {
    type: "integer",
    minimum: 1,
    required: true
  },
  page: {
    type: "integer",
    minimum: 1,
    default: 1
  }
});
```

Empty schema (no params):

``` javascript
N.validate(apiPath, {});
```

**NOTE 1**. We force `additionalProperties: false` by default, to make shure,
that missed params will not be passed without check.

**NOTE 2**. If you ever decide to pass nested objects, remember to define
`additionalProperties: false` on each schema sublevel.