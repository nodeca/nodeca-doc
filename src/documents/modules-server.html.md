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
