---
title: "Menus"
isPage: true
order: 150
---

Menus are special structures - nested trees with permission attributes. Used to
build navigation interface. You can make as many menus as you wish. As all config
data, menu items can be merged from multiple applications

`N.runtime.router` is used to build links for menu items.


Example
-------

``` none
menus:

  common:                         # namespace (package)

    topnav:                       # menu id

      profile:                    # menu item

        to: user.profile          # server method (optional)

        priority: 100             # item priority (optional. default: 100)

        check_permissions: true   # check action permissions to show/hide item
                                  # (optional. default: false.)

      forum:
        to: forum.topics.list

      blogs:
        to: blog.posts.latest_list

      faq:
        to: faq.latest

      sales:
        to: sales.dashboard

      groups:
        to: groups.dashboard

      maps:
        to: maps.dashboard

      translations:
        to: maps.dshboard

  admin:
    system-sidebar:
      settings:
        submenu:
          system:
            to: admin.system.dashboard
            submenu:
              performance:
                to admin.system.performance
              license:
                to: admin.system.license

  user:
    profile-sections:
      blog:
        priority: 5
        to: blog.posts

      friends:
        to: user.friends

      photos:
        to: gallery.albums

      messages:
        to: user.messages

      events:
        to: user.events
```

Menu i18n example
-----------------

```
i18n:
  en-us:
    common:
      menus:
        topnav:
          profile: Profile
          forum: Forum
          blogs: Blogs
          faq: Questions
          sales: Sales
          groups: Groups
          maps: Maps
          translations: Translations
    admin:
      menus:
        system-sidebar:
          settings: Tools & Settings
          settings.system: System Settings
          settings.system.performance: Performance Mode
          settings.system.license: License Key
```


Rendering Menus
---------------

TBD. Should be redesigned.

Currently menu is injected by hook. Structure example:

``` javascript
{
  common: {
    topnav: [
      {
        title: "Profile",
        link: "http://nodeca.org/user/profile"
      },
      // ...
    ]
  },

  admin: {
    "system-sidebar": [
      {
        title: "Tools & Settings",
        childs: [
          {
            title: "System Settings",
            link: "http://nodeca.org/admin/settings",
            childs: [
              {
                title: "Performance Mode",
                link: "http://nodeca.org/admin/performance"
              },
              // ...
            ]
          }
        ]
      }
    ]
  }
}
```

Before rendring views (on server/client), we are using this shared method
to build all menu maps and expose it:

- as `env.response.data.menus` on server
- as `locals.menus` on client
