---
title: "Modules - Client"
isPage: true
order: 95
---

Client modules are independent closures, that can include CommonJS.
They are automatically collected, browserified, joined together, and minified
by the bundler.

All "magic" is in `require` directive. There are several types of
requireable files:

- "vendor" libraries - embedded with global path (or shortname). Should be
  announced in bundler config. Used for global libraries, like "lodash".
- "local" libraries - works as in node.js, embedded once per package.


Also there are some extra stuff available within Nodeca's client modules over
CommonJS specification:

- __module.apiPath__ - contains API path of the module. (e.g. `forum.section`)
- __N__ - local reference to N object.
- __t__ - local wrapper over `N.runtime.t` allows to use translation paths
  relative to the module's API path.


Wire listeners
--------------

There are some common events, that can be emitted from any modules:

- __navigate.to__ - go to another page
- __navigate.exit:<api_path> - fired, prior to leave page with certain api path. Useful
  for resourses cleanup.
- __navigate.exit__ - the same as above, but global (fired every time we leave any page).
  Can be used to control global page objects
- __navigate.done:<api_path>__ - fired page with certain api path, after data loaded
  and rendering compleete. Useful to init internal structures, that depends on DOM and
  another scripts. Can be used instead of $(function(){...}), but for one page
- __navigate.done__ - the same as above, but global (fired every time for all pages).
  Can be used instead of $(function(){...})
- __notify__ - show popup message in top right corner
