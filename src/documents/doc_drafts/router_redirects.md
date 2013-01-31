???

```
router:

  #
  # Redirects
  #

  redirects:
    "/f{forum_id}/thread{thread_id}.php":
      to: [301, "/t-{forum_id}-{thread_id}.html"]
      params:
        forum_id: /\d+/
        thread_id: /\d+/

    "/f{forum_id}.html":
      to: !!js/function >
        function redirect(forum_id, cb) {
          // this is nodeca
          var slugize = this.helpers.slugize;

          this.models.forum.find(forum_id, function (err, forum) {
            if (err) {
              cb(err);
              return;
            }

            cb(null, 301, '/forums/' + forum_id + '-' + sluggize(forum.title));
          });
        }
      params:
        forum_id: /\d+/
```


