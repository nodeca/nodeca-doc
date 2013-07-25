---
title: "Settings"
isPage: true
order: 140
---

Each __setting__ is simple value, combined from multiple sources. For example,
value `can_create_forum_post` depends on:

* member user groups
* current forum
* sometime, current thread

When we need to calculate setting value:

1. user provides setting name (or list) AND additional parameter
   (user_id, forum_id, ...)
2. (value,type) are fetched from every store, defined in schema (type = OR/AND)
3. fetched values are combined (first, by OR, then by AND)


Setting stores
--------------

- __global__ (key) - maps settings from config file, to use in filters
- __usergroup__ (key, [group1_id, ...]) - stores permissions of user groups.
  Supports "restrictive" groups.
- __forum_usergroup__ (key, [group1_id, ...], forum_id) - stores permissions
  of user groups for specific forum.
- __app_users__ (key, application, user_id) - stores user lists for applications
  (for example, lists of local administrators/moderators). Has boolean interface
  (check specific user in list, or add/remove user)

For every setting, store returns "vector":

* setting value
* combining type (OR/AND) - specific for each store.

Every store type is defined by combination of parameters, needed to extract
setting. That's unique for well-designed system.

In database, each store is usually binded to 'setting' field of appropriate
document. It real life, you should not care about store deal, because you'll
reuse existing ones. Settings are defined in config yaml files. Each file can
contain multiple settings. We prefer to group those by roles or by store.

Note, that many fields from yaml config are used only in Admin Control Panel.

Setting definition
------------------

- setting_schemas:
  - **store_name** - Setting store name (e.g. `usergroups`)
    - **key** (unique) - Setting key name (e.g. `can_modify_topic`)
      - **extends** (default = false)- When `true`, means that setting combined
        from several stores. Missed properties taken from base definition.
      - **type**
        (`boolean`|`string`|`text`|`wysiwyg`|`number`|`dropdown`|`combobox`,
        required) - Type of the setting.
      - **default** - Default value. If not set, "empty" value used (false, 0, "", [], and so on)
      - **empty_value** - Used by some setting stores as value of non-existent setting.
        Unlike **default** this should always be a "falsy" value to allow correct fallback to
        setting value from superior settings store.
      - **category_key** - used to combine settings in list, inside ACP
      - **group_key** - used split settings by tabs and groups, for better navigation
      - **priority** (default = 10) - Ordering priority for ACP
      - **values** - array of key-value pairs (like `value_id: "Value String"`)
        or name of dynamic values fetcher function (only `"usergroups"` is
        available for now) for `dropdown` and `combobox` types
      - **validators**
        (`required`|`numeric`|`integer`|`positive_integer`|`regexp`|`custom`,
        optional) - *TBD* reserved for future use

`category_key` - used to combine settings on long page. `group_key` - used to combine
settings in tabs & groups.


Setting group definition
------------------------

Global setting are combined in tabs & groups on control panel. That does not affect
settings logic, and used only in interface

- setting_groups:
  - __group_key__
    - __parent__ - empty for tabs, tab_key for groups
    - __priority__ - order


i18n
----

Paths for settings localizations:

- `admin.core.setting_names.<name>` for setting name itself
- `admin.core.setting_names.<name>_help` for help phrase (description)
- `admin.core.group_names.<name>` for setting group name
- `admin.core.category_names.<name>` for setting category name

Note, we considet, that settings, groups & categories has unique IDs. So,
start group id with "grp_" and categories with "cat_" prefixes.


Example
-------


```
---
setting_schemas:
  global:
    threads_per_page:
      type: number
      default: 30
      group: forum

    posts_per_page:
      type: number
      default: 25
      group: thread

setting_groups:
  tab_system:
    priority: 0
  grp_forum:
    parent: tab_system
    priority: 10
  grp_topic:
    parent: tab_system
    priority: 20
```

```
i18n:
  en-US:
    admin:
      setting:
        tab_system: System
        grp_forum: Forum
        grp_thread: Thread

        threads_per_page: Threads per page
        threads_per_page_help: Default number of displayed thread 

        posts_per_page: Posts per page
        posts_per_page_help: Default number of displayed posts

```


API
---

TBD
