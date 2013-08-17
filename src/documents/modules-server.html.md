---
title: "Modules - Server"
isPage: true
order: 90
---

Files `./server/**/*.js` are loaded & initialized as server methods.

``` none
├─ server/
│   └─ admin/
│       ├─ dashboard.js
│       └─ users.js
```

Module shoud export function, that add all nesessary validators & listeners
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

Server methods are designed to be lite, with minimal hooks count. That will
allow to make nested calls for comples page - when page conteins multiple
widgets. Nested calls should not create session and other things every time.


Request Environment (env)
-------------------------

All requests are executed within separate context, with `env` structure
available:

``` none
env                     # `this` context of actions/filters

  method                # called method name (e.g.: ‘forum.posts.show’)
  params                # request params

  log_request           # internal, low-level logger for responders

  data                  # raw data sandbox (fetched db models and so on)

  err                   # internal, to pass error on finalization in responder
  status
  body                  # internal, used in responder end to prepare reply
  post: null            # internal, filled by formidable with `fields` & `files`
                        # structures, for http POST requests

  headers               # http headers sandbox. (!) don't use `res` directly

  origin                # low-level data, rarely used, mostly to determine request type
    req                 # real server request and server response objects.
    res                 #

  session_id            # session id as hex-encoded string
  session               # session data
    ip
    csrf
    user_id
    locale

  req                   # request details
    ip                  # request ip
    type                # responder type (http/rpc)
    isEncrypted         # is current request performed via https
    matched             # matched route cache, to avoid duplicate router call

  res                   # response sandbox:
                        #
    head                # (optional) { title: null }, data for html head
    blocks              # widgets data (breadcrumbs and so on)
    menus               # (http only) static menus
    layout              # (http only) site layout

  t(name[, params])     # server-side Babelfish#t wrapper.
                        # uses right locale and prepends env.method to name.
  t.exists(name)

  helpers                   # helpers for view templates
    t(name[, params])       # babelfish.t proxy, without `language` param
    t.exists(name)
    apiPath                 # returns API path requested server method (‘forum.posts.show’)
    content                 # rendered part of page, for embedding into layout
    set_layout(name)        # allows to change default page layout
    link_to(name[, params]) # `N.runtime.route.linkTo` alias for templates
    asset_path(path)        # returns path to Mincer's asset
    asset_include(path)     # returns compiled Mincer's asset as a string
    date                    # date manipulation helper
    add_raw_data(key, val)  # add new key into `runtime` object (see below)

    # wrapper over `N.runtime.router.linkTo`
    # construts full url using current env for default protocol/host.
    # use `linkDefaults` object to specify protocol. (port will be detected)
    url_to(apiPath[, params[, linkDefaults]])

  extras                # shared storage for data (used for helpers)
    puncher()

    getCookie(name)                   # get value of input cookie, *not* output
    setCookie(name, value[, options]) # set output cookie

    settings            # optional sandbox for settings (permissions) fetch
      params            # required for fetch
      fetch()

  runtime               # data, injected into http page, used to pass variables
                        # for javascript
    layout
    csrf

    locale
    user_name
    is_member
    is_guest
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
