---
title: "Database"
isPage: true
order: 50
---

Migrations
----------

### Usage (CLI)

``` bash
$ ./nodeca.js migrate          # show available migration
$ ./nodeca.js migrate --all    # apply pending
$ ./nodeca.js migrate -h       # help
```

### API

Migrations are stored in `./db/migrate` directory, one per file. File name
format must be `YYYYMMDDhhmmss_<migration-name>.js`. Migrations run from old
to new.

```
├─ db/migrate/
│       ├─ 20110919181104_create_sections.js
│       └─ 20120103183744_create_threads.js
│
```

Each migration script exports async method `up(N, callback)`.

``` javascript
module.exports.up = function(N, callback) {
  my_model = new N.models.my_model(/* data */);

  my_model.save(function (err) {
    callback(err);
  });
}

```

Seeds
-----

### Usage (CLI)

``` bash
$ ./nodeca.js seed             # list available seeds, with id
$ ./nodeca.js seed -n XXX      # apply seed by id
$ ./nodeca.js seed -h          # show help about other options
```

### API

Seed API is similar to migrations, but more simple. All seeds are placed in
`./db/seeds` folder, one seed in each *.js file. Each file exports async
function, that applies seed.

**NOTE**. Loading seeds is limited to development/test enviroment. If you really
need to run seed on production/staging, you must use option -f (--force)


Data snapshots
--------------

There are couple of development scripts, to quickly switch between data states,
when you actively change DB.

``` bash
$ ./bin/db-dump <snapshot-id>    # make snapshot with given id into `./tmp`
```

Note, that dump can contain multiple files (MongoDB, Redis).

``` bash
$ ./bin/db-restore <snapshot-id> # restores data from snapshot with given id.
```

(!) scripts force use development enviroment, to exclude posibility of data
corruption
