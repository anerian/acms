(function($){   
  $.fn.numberedDL = function(options) {
    options = $.extend({}, options || {});
    return this.each(function() {      
      new NumberedDL(this, options);
    });
  };
  
  function NumberedDL(element, options) {
    this.element = $(element);
    this.loader  = 1;
    this.items   = [];
    this.current = 0;
    this.timer   = null;
    this.list    = $('ol');
    this.preload = $('li', this.list);
    this.image   = this.element.find('img:first');
    this.content = $('.dl-description p');
    this.title   = $('.dl-description h2 a');
    
    for (var i = 0, len = this.preload.length; i < len; ++i ) {
      var anchor = $('a:first', this.preload[i]);
      
      var that = this;
      
      anchor.data('index', i).click(function(event) {
        that.jump(event, $(this).data('index'));
      });
    }
    
    this.imageLoaded(0, this.image, this.title.html(), this.title.attr("href"), this.content.html());
    
    setTimeout(function(){that.loadImages()}, 100);
  }
  
  NumberedDL.prototype = {
    imageLoaded: function(index, image, title, link, content) {
      if (index) {
        var anchor = document.createElement("a");
        anchor.href = link;
        image.appendTo(anchor);
        $(anchor).appendTo(this.element);
      }
      this.items.push( { title: title, link: link, content: content, image: image } );
    },
    
    loadImages: function() {
      var that = this;
      var preloadItem = this.preload[this.loader];

      var title   = $('a:first', preloadItem).attr("title");
      var link    = $('a:first', preloadItem).attr("href");
      var content = $('cite:first', preloadItem).html();

      var image = $(document.createElement('img'));      
      image.attr('src', $('ins:first', preloadItem).html());
      image.hide();
      
      try {
        image.load(function(event) {
          that.imageLoaded(that.loader,image,title,link,content);
        });
      } catch(e) {
        this.imageLoaded(this.loader,image,title,link,content);
      }
      this.loader++;
      
      if (this.preload.length > this.loader) { setTimeout(function(){that.loadImages()}, 100); }
      else {
        this.timer = setTimeout(function(){that.rotate()}, 4000); // all loaded start rotating
      }
    },

    onAppear: function(item) {
      var that = this;
      this.appear = null;
      this.title.html(item.title);
      this.title.attr("href", item.link);
      this.content.html(item.content);
      
      this.timer = setTimeout(function(){that.rotate();}, 4000);
    },
    
    rotate: function(jump) {      
      var next = (this.current + 1);
      if (jump || jump == 0) {
        next = jump;
        if (this.fade) { this.fade.stop(); }
        if (this.appear) { this.appear.stop(); }
        if (this.timer) { clearTimeout(this.timer); }
      }
      if (next == this.current) return;
  
      if (next >= this.items.length) {
        next = 0;
      }
      var that = this;
      var currItem = this.items[this.current];
      var nextItem = this.items[next];
      
      // fade the images in and out
      this.fade = $(currItem.image);      
      this.fade.fadeOut(1500, function(){
        that.fade = null;
      });
      this.appear = $(nextItem.image);
      this.appear.fadeIn(1500, function(){
        that.onAppear(this);
      });
      
      this.current = next;
      
      $(this.preload[this.current]).removeClass("selected");
      $(this.preload[next]).addClass("selected");
    },
    
    jump: function(event, index) {
      event.preventDefault();
      this.rotate(index);
    }
  };
})(jQuery);