YouthTree.withNS('Gallery', function(ns) {
  var InnerGallery;
  InnerGallery = function(selector) {
    this.selector = selector;
    this.items = $(this.selector);
    this.urls = this.items.map(function() {
      return this.href;
    }).toArray();
    this.bindEvents();
    return this;
  };
  InnerGallery.prototype.bindEvents = function() {
    var self;
    self = this;
    return this.items.click(function(e) {
      e.preventDefault();
      self.showFor(this);
      return false;
    });
  };
  InnerGallery.prototype.showFor = function(element) {
    var href, index;
    href = element.href;
    index = this.urls.indexOf(href);
    return index >= 0 ? this.showImages(this.urls.slice(index).concat(this.urls.slice(0, index))) : null;
  };
  InnerGallery.prototype.showImages = function(images) {
    return $.facybox({
      images: images
    });
  };

  ns.galleries = {};
  ns.create = function(name, selector) {
    var gallery;
    gallery = new InnerGallery(selector);
    ns.galleries[name] = gallery;
    return gallery;
  };
  ns.get = function(name) {
    return ns.galleries[name];
  };
  return ns.get;
});