---
title: "Models"
isPage: true
order: 130
---

Models are stored under `./models` directory and become available as subtree
under `N.models`:

```
├─ models/
│   ├─ foo/
│   │   ├─ Bar.js   # N.models.foo.Bar
│   │   └─ ...
│   └─ Aha.js       # N.models.Aha
```

Each model exports:

1. Model schema (or several schemas)
2. __init__() consctuctor, that build model.

That allows to modify schemas via hooks.

``` javascript
// file  : model/blog/Entry.js
// api   : N.models.blog.Entry

var mongoose = N.runtime.mongoose;

var Comments = module.exports.Comments = new mongoose.Schema({
    title     : String
  , body      : String
  , date      : Date
});

var Entry = module.exports.BlogPost = new mongoose.Schema({
    author    : ObjectId
  , title     : String
  , body      : String
  , date      : Date
  , comments  : [Comments]
  , meta      : {
        votes : Number
      , favs  : Number
    }
});

module.exports.__init__ = function() {
  return mongoose.model('blog.Entry', Entry);
};
```
