BHM.defineMixin 'Callbacks', (mixin) ->

  mixin.callbacks: {}

  mixin.defineCallback: (key) ->
    @["on$key"]:     (callback) -> @hasCallback key, callback
    @["invoke$key"]: (args...)  -> @invokeCallbacks key, args...

  mixin.hasCallback: (name, callback) ->
    callbacks: mixin.callbacks[name]?= []
    callbacks.push callback
    true

  mixin.callbacksFor: (name) ->
    existing: mixin.callbacks[name]
    if existing? then existing else []

  mixin.invokeCallbacks: (name, args...) ->
    for callback in mixin.callbacksFor(name)
      return false if callback(args...) is false
    true