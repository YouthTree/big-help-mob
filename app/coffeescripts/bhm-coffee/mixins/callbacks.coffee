BHM.defineMixin 'Callbacks', (mixin) ->

  mixin.callbacks: {}

  mixin.hasCallback: (name, callback) ->
    callbacks: mixin.callbacks[name]?= []
    callbacks.push callback

  mixin.callbacksFor: (name) ->
    existing: mixin.callbacks[name]
    if existing? then existing else []

  mixin.invokeCallbacks: (name, args...) ->
    callback(args...) for callback in mixin.callbacksFor(name)