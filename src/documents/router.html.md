---
title: "Router"
isPage: true
order: 110
---


For server and client purposes we use [Pointer][Pointer] router.
Routes are described in YAML and bundled into main api tree file as
`N.config.router` after init. Router instanse is accessible as
`N.runtime.router`.

Router config for the client is kept under `N.runtime.client_routes`.

## Application Routes

Application routes are defined in `router` section of config files:

``` none
router:
  http.get:
    forums.list:
      "/f{forum_id}/":
        forum_id: /\d+/
      "/f{forum_id}/index({page}).html":
        forum_id: /\d+/
        page:
          match: /[2-9]|[1-9]\d+/
          default: 1

    forums.threads.show:
      "/f{forum_id}/thread{thread_id}(-{page}).html":
        forum_id: /\d+/
        thread_id: /\d+/
        page:
          match: /[2-9]|[1-9]\d+/
          default: 1

    forums.threads.redirect:
      "/f{forum_id}/thread{thread_id}-{goto}.html":
        forum_id: /\d+/
        thread_id: /\d+/
        goto: /new-post|last-post/

    search:
      "/search/": ~
```

All routes are splitted into groups by responders they are related.
That groups may be specialized by dot-separated list of HTTP methods.
In the above example there is the only responder `http` with `get` method.
It means that declared routes will be served by `http` responder and only for
GET HTTP method. Method names in the config must be lowercased. `get` method
always implies `head` method as well.

**NOTICE**. Routes with leading `#` are used by clients ONLY.
__Not implemented yet__

**SECURITY WARNING**. NEVER make routes, that change application state.
Such actions should go via rpc, that has CSRF protection. 


### Route Params Options

Optional:

- **match** (Optional) Rule to match value of param, `Array` or `RegExp`.
- **default** (Optional) Default value of param.

See example above and [Pointer][Pointer-Route] `new Route` documentation
of `params` options.


### Slugs

Routes can contain slugs. Technically, that's usual optional params.

``` none
router:
  http.get:
    faq.post.show:
      "/qa/({categoryslug}/){post_id}(-{postslug}).html": ~
```

The route above will match any of the following URLs:

``` none
/qa/123.html
/qa/123-pochemu-krokodil-zelyoni.html
/qa/animals/123-pochemu-krokodil-zelyoni.html
```

Recommended behavior for app developers is to redirect all non-full url's
with 302 code. This can be done with `before` filter. Note, that it's a good
idea to cache full url (or md5) - to avoid recalculations on every request.


**CAUTION**. NEVER route http methods, that posts data. That will
cause CSRF vulnerability. **ONCE AGAIN**. Only give  access to http "read"
methods, that will not modify data. Posting should be done ONLY via rpc
call, when user click on links, buttons, and so on. 


### Overrides

If you are not satisfied with defaul routes, you can wish to override those at
application-level config. Any config object can have special key
`~override: true`. When such key found, branches from other configs will be
wiped. Without this key, objects are reqursively merged.

``` none
router:
  http.get:
    forums.list:
      ~override: true
      "/forum{forum_id}/":
        page: /[01]/
        forum_id: /\d+/
    # ...
```



## Mounting (and binding) applications

Mounting (and binding) of applications is described in `bind` section of config
files. It has _API path_ as key and options of it's binding as values, e.g.:

```
bind:
  default:
    listen: 0.0.0.0:3000

  forums:
    mount: /forum
```


Options are Objects of key-value pairs. All parts are optional:

- **listen** (String): Which `address[:port = 80]` we should listen. It is
  useful when you want to bind different parts of application on different
  interfaces, e.g. use SSL for users only, or separate interface for assets.
- **mount** (String): Mount point given in form of `[proto:][//[host][:port]][/path]`,
  all parts are optional. You can use any combination. Examples:
  - `https://users.nodeca.org`:
    mount to the root of `users.ndoca.org` host using HTTPS protocol only.
  - `//beta.nodeca.org:3000`:
    mount to the root of `beta.ndoca.org:3000` host using any protocol.
  - `/forum`:
    mount to the `/forum` path of any host using any protocol.
  - `//dev.nodeca.org:3000/users`:
    mount to the `/users` path of `dev.nodeca.org:3000` host using any protocol.
  - `//:3000/`
    mount to the root of any host and any protocol at 3000 port.
  - `http:/forum`
    mount to the `/forum` at `http` protocol of any host and port.
- **ssl** (Object): Contains paths to `key` and `cert` files. Paths are
  relative to the main app root, but you may specify _absolute_ pathname that
  starts with a leading slash. You also can use _one_ file (*.pem) as either
  `key` and `cert` - just concatenate them using a text editor.


### HTTPS

As you can see above you can make nodeca start SSL server. Here's an example
configuration that starts an https server on 443 port:

```
bind:
  default:
    listen: 0.0.0.0:443
    mount:  https://dev.nodeca.org
    ssl:
      key:  ./etc/server.key
      cert: ./etc/server.cert
```

You may also want to use stunnel for HTTPS while running nodeca application in
normal mode, for this purposes you MUST NOT specify `ssl` option, and provide
only a protocol-specific mount point:

```
bind:
  default:
    listen: 127.0.0.1:3000
    mount:  https://dev.nodeca.org
```


#### Generating self-signed SSLcertificate

``` bash
openssl genrsa -des3 -out server.key 1024
openssl req -new -key server.key -out server.csr

cp server.key server.key.orig
openssl rsa -in server.key.orig -out server.key

openssl x509 -req -days 365 -in server.csr \
        -signkey server.key -out server.cert
```


### Fallbacks

You can mount/bind any part of N.wire's `server:**` channel, even serve
`forum.posts` and `forum.threads` by different address:port points.

When you specify mount/bind options for `forum` and `forum.posts`, the last one
will use options of `forum` as "defaults". In this case we can describe the way
of fallbacks as follows:

   bind['default'] + bind['forum'] + bind['forum.posts']


#### Default mount/binding point

You can use `default` bind-level key to describe "default" fallback mount point.
Options of this case are used as "defaults" for all server methods and take
place, when method has no mount/bind options:

```
default:
  listen: 0.0.0.0:80

forum:
  mount: /forum

#
# equals to:
#

default:
  listen: 0.0.0.0:80

forum:
  listen: 0.0.0.0:80
  mount: /forum
```


### Handling invalid hosts

There is a _special case_ bind-level key `_` for the _invalid hosts_ handler:

```
bind:
  _: !!js/function |
    function (req, res) {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('Invalid host ' + req.headers.host);
    }
```


[Pointer]:        https://github.com/nodeca/pointer
[Pointer-Route]:  http://nodeca.github.com/pointer/#Route.new
