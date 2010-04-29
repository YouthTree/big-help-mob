NHC: {}

NHC.makeNamespace: (name, $) ->

  scopedClosure: (closure, scope) ->
    closure.call scope, scope if $.isFunction closure
  
  # Base is the default mixin for namespaces.
  base:  {}
  
  namespace: (name, parent) ->
    @currentNamespaceKey: name
    @parentNamespace:     parent
    @children:            []
    @parentNamespace.subNamespaceAdded(@) if @parentNamespace?
  
  namespace.prototype: base
    
  # Simplified method of setting up a namespace.
  makeNS: (name, parent) ->
    new namespace name, parent
  
  ns: makeNS name
  
  # Configurable options for require
  base.baseJSPath:   '/javascripts/'
  base.baseJSSuffix: ''
  
  base.subNamespaceAdded: (ns) ->
    @children.push ns
  
  # Converts a string to the associated underscored representation.
  # Moslty used for converting namespaces (e.g. Eoraptor.A.B) to a file
  # path ("eoraptor/a/b").
  base.underscoreString: (s) ->
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
      currentNS[name] = makeNS(name, currentNS) if not currentNS[name]?
      currentNS: currentNS[name]
    hadSetup: $.isFunction currentNS.setup
    scopedClosure closure, currentNS
    currentNS.setupVia currentNS.setup if not hadSetup and $.isFunction currentNS.setup
    currentNS
    
  base.extendBase: (closure) ->
    scopedClosure closure, base
    
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
      path:   base.underscoreString "${@toNSName()}.$name"
      url:    "${base.baseJSPath}${path}.js${base.baseJSSuffix}"
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
    
  base.isRoot: ->
    @parentNamespace?
    
  base.alias: (as, from) ->
    return unless from?
    

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
    
  base.getRootNS: ->
    current: @
    current: current.parentNamespace while current.parentNamespace?
    current
    
  ns

NHC.defineNamespace: (name) ->
  window[name]: @makeNamespace name, jQuery
  

NHC.defineNamespace 'BHM'