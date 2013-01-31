---
title: "HTTP/RPC requests"
isPage: true
order: 100
---

There are 2 ways to  call server methods

1. Via http GET requests, if router has matching rule
2. Via `N.io.rpc` call from client JS (that's special POST-request)

Data flow is almost the same. With only 2 differences:

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

By default, no cache exists, except static/assets servers. But you can extend
support for some responders, to improve performance.


### Cache static content

Those MUST have unique name for each unique content. Then we set

```
Cache-Control: public, maxage=31536000
Vary: Accept-Encoding (for compressable data)
ETag: xxxxxxxxxxxxxxxxxxxxxxxxxxxx
Last-Modified: yyyyyyyy
```

**Be careful** with `Last-Modified` in clustered enviroment, if those relies
on file dates.

N.B. Check if `Last-Modified` can be safely skipped


### Cache dynamic data

Dynamic pages mostly depends on user id & language. That sould be cared, if
someone like to make dynamic pages cacheable. You should directly specify
headers for pages, that should use cache advantages:

```
Cache-Control: private, max-age=0, must-revalidate
ETag: [contend_id]-[user_id]-[lang_id]-[theme_id]
```

* NO `Last-Modified` (suppress HTTP/1.0 caches)
* NEVER use `Expires` - it can fuckup user difference, if behind HTTP/1.0 cache.

Renderer checks if `env.response.headers['ETag']` === 
env.http.req.headers['if-none-match']`, and skip rendering phase if necessary.
But it's still your responsibility to fill `ETag` & `Cache-Control` fields.

Notes:

* For persistent objects, it's good idea to use random number as etag, and
  update it on any object change. Or use update timestamp as etag.
* Page content can depend on user avatars. It's not correct to cache such pages
  more than several days (to avoid VERY complex dependencies) (but we still can
  safely cache those pages for guests)


### Cache 404, 410 pages

* Set infinity cache for `not found` binary files (public)
* Set 1 year cache for invalid pages, **missed from router paths**
* DON'T set 404 cache time for pages, that CAN depend on user permissions
  (all other pages). Use the same strategy, as for "working" pages.


### HEAD requests optimization

1. Renderer returns empty body on HEAD requests.
2. Assets are optimized too.

If you add new type of binary responder - take care about HEADs.
