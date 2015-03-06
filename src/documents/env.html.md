---
title: "env (in requests)"
isPage: true
order: 105
---


Each request creates `env` object, that is piped via set of handlers. Env
contains all info about request and collects output data.

See current `env` structure below.

**NOTE**. `env` should avoid functions, to be transparent for
server-server communications. But we have exclusion for `static` helpers

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

  user_info             # some current user data, frequently used to process request
    hb                  # boolean, is user hell-banned
    is_guest
    is_member
    user_id             # null for guest


  req                   # request details
    ip                  # request ip
    type                # responder type (http/rpc)
    isEncrypted         # is current request performed via https
    matched             # matched route cache, to avoid duplicate router call

  res                   # response sandbox:
    head                # (optional) { title: null }, data for html head
    blocks              # widgets data (breadcrumbs and so on)
    menus               # (http only) static menus
    layout              # (http only) site layout
    settings            # (optional) settings/permissions

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
    add_raw_data(key, val)  # add new key into `runtime.page_data` object (see below)

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
    used_id             # '000000000000000000000000' for guest
    user_hid            # 0 for guest
    user_avatar         # avatar media id in filestore, or null for guest
    is_member
    is_guest

    page_data           # raw page data, for in-place rendering (by knockout,
                        # for example). Defined via `add_raw_data`
                        # helper in template

    recaptcha
```
