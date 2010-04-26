# If not already setup, make Eoraptor an empty object.
BHM ?= {}

# Now, use a nested closure with the namespace object and jquery.
((ns, $) ->

  scopedClosure: (closure, scope) ->
    closure.call scope, scope if $.isFunction closure
  
  # Base is the default mixin for namespaces.
  base:  {}
  
  # Configurable options for require
  ns.baseJSPath:   '/javascripts/';
  ns.baseJSSuffix: ''
  
  # Simplified method of setting up a namespace.
  makeNS: (o, name, parent) ->
    obj: $.extend o, base
    obj.currentNamespaceKey: name
    obj.parentNamespace:     parent
    obj
  
  # Converts a string to the associated underscored representation.
  # Moslty used for converting namespaces (e.g. Eoraptor.A.B) to a file
  # path ("eoraptor/a/b").
  ns.underscoreString: (s) ->
    s.replace(/\./g, '/').replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2').replace(/([a-z\d])([A-Z])/g, '$1_$2').replace(/-/g, '_').toLowerCase()
  
  # Returns the nested name for this namespace.
  base.toNSName: ->
    parts: []
    current: @
    while current
      parts.unshift current.currentNamespaceKey
      current: current.parentNamespace
    parts.join '.'
    
  # Defines / retrieves a namespace, relative to this.
  # e.g. Eoraptor.withNS('Awesome', function(ns) { // ... })
  # will define Eoraptor.Awesome as a new namespace and
  # if given, will invoke the given closure with it as
  # an argument
  base.withNS: (key, closure) ->
    parts: key.split "."
    currentNS: @
    for name in parts
      currentNS[name] = makeNS({}, name, currentNS) if not currentNS[name]?
      currentNS: currentNS[name]
    hadSetup: $.isFunction currentNS.setup
    scopedClosure closure, currentNS
    if not hadSetup and $.isFunction currentNS.setup
      currentNS.setupVia currentNS.setup
    currentNS
    
  # Get, if defined, the given namespace.
  base.getNS: (key) ->
    parts: key.split "."
    currentNS: @
    for name in parts
      return unless currentNS[name]?
      currentNS = currentNS[name]
    currentNS
    
  
  # Checks whether a sub-namespace is defined for this object.
  base.isNSDefined: (key) ->
    @getNS(key)?
    
  
  # Require a namespace. If it already present, it will invoke
  # the callback block with it as an argument otherwise it will
  # first load the file and then it will invoke the block, passing
  # the namespace as an argument. Useful for dynamic requires.
  base.require: (name, callback) ->
    if not @isNSDefined(name)
      path: ns.underscoreString("${@toNSName()}.$name")
      url: "${ns.baseJSPath}${path}.js${ns.baseJSSuffix}"
      script: $ "<script />", {type: "text/javascript", src: url}
      script.load -> callback @getNS(name) if $.isFunction callback
      script.appendTo $ "head"
    else
      callback @getNS(name) if $.isFunction callback
      
  # Automatically call the given function on document ready if
  # autosetup is enabled and it is a function. Will apply in the
  # scope of it's caller.
  base.setupVia: (f) ->
    $(document).ready =>
      scopedClosure(f, @) if @autosetup?
  
  # Define a class under the current namespace.
  base.defineClass: (name, closure) ->
    klass: ->
      @initialize.apply @, arguments if $.isFunction @initialize
    scopedClosure closure, klass.prototype
    @[name] = klass
    klass

  # Equivalent to console.log but prefix with the current namespace
  base.log: (args...) ->
    console.log "[${@toNSName()}]", args...
    
  base.debug: (args...) ->
    console.log "[Debug - ${@toNSName()}]", args...

  # If set to false, the setup blocks in namespaces wont be
  # automatically called on document ready.
  base.autosetup: true
  
  # Read / set a data attribute on an object.
  base.data: (object, key, value) ->
    object: $(object) if typeof object is "string" 
    data: "data-${key.replace(/_/g, '-')}"
    if value?
      object.attr data, value
    else
      object.attr data
  
  base.hasData: (object, key) ->
    object: $(object) if typeof object is "string"
    object.is "[data-${key.replace(/_/g, '-')}]"
  
  # Returns the value of the given meta key. 
  base.getMeta: (key) ->
    $("meta[name='$key']").attr("content")
      
  
  # Setup the default namespace, in this case eoraptor.
  makeNS ns, 'BHM'
  
)(BHM, jQuery)