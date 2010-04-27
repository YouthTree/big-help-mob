BHM.withNS 'Mixins', (ns) ->

  ns.mixins:  {}
  BHM.mixins: {}

  BHM.extendBase (base) ->
    base.mixin: (mixins) -> ns.mixin @, mixins

  defineMixin: (key, mixin) -> @mixins[key]: mixin

  BHM.defineMixin: defineMixin
  ns.define:       defineMixin

  ns.lookupMixin: (mixin) ->
    switch typeof mixin
    when "string"
      if ns.mixins[mixin]?
        ns.mixins[mixin]
      else if BHM.mixins[mixin]?
        BHM.mixins[mixin]
      else
        {} # unknown mixin, return a blank object.
    else
      mixin

  ns.invokeMixin: (scope, mixin) ->
    switch typeof mixin
    when "string"
      ns.invokeMixin scope, ns.lookupMixin(mixin)
    when "function"
      mixin.call scope, scope
    when "object"
      $.extend scope, mixin

  ns.mixin: (scope, mixins) ->
    mixins: [mixins] unless $.isArray mixins
    ns.invokeMixin scope, ns.lookupMixin(mixin) for mixin in mixins