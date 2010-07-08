BHM.withNS('Mission', function(ns) {
  ns.abbrselector = '#pickups-listing li abbr';
  ns.imgSelector = '#mission-photos a';
  ns.setup = function() {
    $(ns.abbrSelector).tipsy({
      title: function() {
        return this.getAttribute("original-title").replace(/,/g, '<br />');
      },
      gravity: 'e',
      fade: true,
      html: true
    });
    YouthTree.Gallery.create('mission-gallery', ns.imgSelector);
    return ns.bindNinjas();
  };
  ns.unicorns = function() {
    var cycleColumns, cycleRows, gallery, items, perRow, rows;
    gallery = YouthTree.Gallery.get('mission-gallery');
    items = gallery.items;
    perRow = 9;
    rows = Math.ceil(items.size() / perRow);
    cycleRows = function(cb) {
      var row;
      row = 0;
      return setInterval((function() {
        var start;
        start = row * perRow;
        cb(items.slice(start, start + perRow), items);
        row = (row + 1) % rows;
        return row;
      }), 250);
    };
    cycleColumns = function(cb) {
      var column;
      column = 0;
      return setInterval((function() {
        column = (column + 1) % perRow;
        return cb(items.filter((":nth-child(" + (perRow) + "n+" + (column) + ")")), items);
      }), 250);
    };
    return [cycleRows, cycleColumns];
  };
  ns.ninjas = function() {
    var cb, u;
    cb = function(i, i2) {
      i2.removeClass('active');
      return i.addClass('active');
    };
    u = ns.unicorns();
    u[0](cb);
    return setTimeout((function() {
      return u[1](cb);
    }), 125);
  };
  ns.bindNinjas = function() {
    var code, keys;
    keys = [];
    code = "66,72,77";
    return $(document).keydown(function(e) {
      keys.push(e.keyCode);
      if (keys.join(",").indexOf(code) > -1) {
        ns.ninjas();
        return $(this).unbind('keydown');
      }
    });
  };
  return ns.bindNinjas;
});