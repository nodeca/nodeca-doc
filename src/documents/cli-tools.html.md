---
title: "CLI (console tools)"
isPage: true
order: 40
---

Usage
-----

General call format:

``` bash
$ ./nodeca.js <command> [options]
```

In real life:

``` bash
$ ./nodeca.js migrate --all
$ ./nodeca.js -h
$ ./nodeca.js seed -h
$ ./nodeca.js server
```


API
---

Commands are stored in `./cli/**/*.js` files. Each file exports config for
single command. See description below.


### commandName

Optional. Name of command, registered by this module. If empty or not exists,
then file name will be used (without extention).


### parserParameters

Object with parser parameters

```javascript
module.exports.parserParameters = {
  version: nodeca.runtime.version,
  addHelp:true,
  help: 'controls nodeca server',
  description: 'Controls nodeca server ...'
};
```

*Note:* See also [ArgumentParser objects](http://docs.python.org/dev/library/argparse.html#argumentparser-objects)
and [sub-commands](http://docs.python.org/dev/library/argparse.html#sub-commands)
in original parser guide.


### commandLineArguments[]

List of arguments definitions.

```javascript
module.exports.commandLineArguments = [
  { args: ['-p','--port'], options: { type: 'int'} },
  { args: ['--host'], options: {defaultValue: 'localhost'} }
];

```

*Note:* See also  [add_argument()](http://docs.python.org/dev/library/argparse.html#the-add-argument-method)
in parsed docs.


### run(N, args, callback)

Emits neccessary init sequence, and executes command code.

```javascript
module.exports.run = function (N, args, callback) {
  N.wire.emit([
      'init:models',
      'init:stores',
      'init:migrations',
      'init:bundle',
      'init:server'
    ], N,
    function (err) {

      /* Do things here */

    }
  );
};
```

`args` - object with parsed arguments.