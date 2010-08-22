BHM.withNS 'Debug', (ns) ->
  
  ns.getCurrentUUID = ->
    nodes = document.body.childNodes
    for node in nodes
      if node.nodeName is "#comment"
        data = node.data
        match = data.match /bhm-request-uuid:\s*(\S+)\s*/
        return match[1] if match?
  
  ns.showDebugInformation = ->
    uuid = ns.getCurrentUUID()
    alert "Current Request UUID: #{uuid}" if uuid?