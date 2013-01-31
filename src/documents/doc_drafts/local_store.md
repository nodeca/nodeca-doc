Local Store
-----------

Local store is used to cache templates & languages - that minimize page load
time. Key name format:

```
  <namespace>_phrases       # serialised phrases resource
  <namespace>_phrases_crc   # phrase resource crc
  <namespace>_templates     # serialized templates resource
  <namespace>_templates_crc # templates resource crc
```

(?) preferables storage type is LocalStorage. But you ca use other one. See
details here http://stackoverflow.com/questions/1194784/which-browsers-support-html5-offline-storage .

