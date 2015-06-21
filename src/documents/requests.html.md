---
title: "HTTP/RPC requests"
isPage: true
order: 100
---

All requests pass vie several nested stages:

1. __Responder__ - (HTTP/RPC/WS/..) converts requests/responses from different
  sources to unified format.
2. __Server chain wrapper__ - (optional) used to assign hooks for dynamic pages
  (exclude files, like assets/static).
3. __server__ or __server_bin__ chain - methods for dynamic pages and static
  files.

Example:

```
http start -> wrapper start -> method -> wrapper end -> http end
```

- RPC data is not rendered, and returned as JSON
- low-level request info is located in `env.origin.rpc` or `env.origin.http`


Request end / redirect / terminate
----------------------------------

It's possible to terminate request chain by passing error as callback argument.
You can control status code, headers and body by passing an `Object` with
following fields:

* __code__ (Number) - Status code
* __head__ (Object, optional) - Response headers, e.g. `{ Location: '/foobar' }`
* __data__ (Object|String, optional) - Response data (object will be converted to JSON)

Sugar:

* `callback(number)` is equal to `callback({code: number})`
* `callback(string)` or `callback(new Error(...))` are equal to `callback({code: 500, data: ...})`

**NOTE** Available status codes are defined in  [N.io](https://github.com/nodeca/nodeca.core/blob/master/lib/system/io.js)

Redirect example:

``` javascript
...
callback({
  code: N.io.REDIRECT,
  head: {
    "Location": N.runtime.router.linkTo(env.request.method, {
      id:   env.params.id,
      page: max
    })
  }
});
return;
```

Adding cache support
--------------------

By default, no cache exists, except for static/assets servers. But you can extend
support for some responders, to improve performance.


### Cache static content

Those MUST have unique name for each unique content. Then we set

```
Cache-Control: public, maxage=31536000
Vary: Accept-Encoding (for compressable data)
ETag: xxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**NOTE**. In clustered environment, file date should not be used to calculate ETag.


### Cache dynamic data

Dynamic pages mostly depends on user id & language. That should be cared, if
someone like to make dynamic pages cacheable. You should directly specify
headers for pages, that should use cache advantages:

```
Cache-Control: private, max-age=0, must-revalidate
ETag: [contend_id]-[user_id]-[lang_id]-[theme_id]
```

* NO `Last-Modified` (suppress HTTP/1.0 caches)
* NEVER use `Expires` - it can fuckup user difference, if behind HTTP/1.0 cache.

Renderer checks if `env.response.headers['ETag']` === 
`env.http.req.headers['if-none-match']`, and skip rendering phase if necessary.
But it's still your responsibility to fill `ETag` & `Cache-Control` fields.

**NOTE** Page content can depend on user avatars. It's not correct to cache such
pages more than several days (to avoid VERY complex dependencies).


### Cache 404, 410 pages

* Set infinity cache for `not found` binary files (public)
* Set 1 year cache for invalid pages, **missed from router paths**
* DON'T set 404 cache time for pages, that CAN depend on user permissions
  (all other pages). Use the same strategy, as for "working" pages.


### HEAD requests optimization

1. Renderer returns empty body on HEAD requests.
2. Assets are optimized too.

If you add new type of binary responder - take care about HEADs.


RPC protocol spec
-----------------

### Request

`$.post('/io/rpc', payload)`

``` none
version       # application version (client need to refresh on server update)
csrf          # CSRF token (received on page load via HTTP)
methods       # PRC method name (`forum.post`)
params        # RPC call params
```

### Reply

``` none
version       # app version
error         # env.err if exists
response      # env.response (if no error)
  layout      # needed to render ajax
  view        # optional, = method by default
  data        # env.response.data
```