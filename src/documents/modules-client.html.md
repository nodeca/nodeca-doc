---
title: "Modules - Client"
isPage: true
order: 95
---

Client modules are just regular CommonJS modules. They are collected,
browserified, joined together, and minified by the bundler automatically.
The only deviation is that it's not possible to use `require` with expressions
as a module path. Only string literals are allowed.

Any dependencies on unbundled files (not declared in bundle.yml) or external
CommonJS libraries of a client module will be detected and embeded into the
same bundle. Note if a required file is allready bundled (not embeded!) into a
different Bundler's package - you must declare the dependecy in bundle.yml
manually.

**NOTE** "bundled" and "embeded" have different meanings. "bundled" means a
file manually declared in `client` or `vendor` sections of bundle.yml. However
"embeded" means _automatically_ detected and injected dependency file of a
module.

Also there are some extra stuff available within Nodeca's client modules over
CommonJS specification:

- `module.apiPath` - contains API path of the module. (e.g. `forum.section`)
- `N` - local reference to N object.
- `t` - local wrapper over `N.runtime.t` allows to use translation paths
  relative to the module's API path.


Predefined Wire channels
------------------------
- `navigate.to` - accepts URL string or object with keys `apiPath` and `params`
- `navigate.exit` - fires when leaving current page
- `navigate.done` - fires when new page is completely loaded
