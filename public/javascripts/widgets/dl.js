var NumberedDL = Class.create({
// expects initial element to be rendered in the DOM
// other items should appear as links in ordered list, with id to element in list as anchor ref attribute
  initialize: function(element) {
    // grab the ordered list
    this.element = $(element);
    this.list    = this.element.down("ol");
    this.preload = this.list.select("li");
    this.image   = this.element.down("img");
    this.content = this.element.down(".dl-description p");
    this.title   = this.element.down(".dl-description h2 a");
    this.loader  = 1;
    this.items   = [];
    this.current = 0;
    this.timer   = null;

    for( var i = 0, len = this.preload.length; i < len; ++i ) {
      var anchor = this.preload[i].down("a");
      anchor.observe("click", this.jump.bindAsEventListener(this,i));
    }

    this.imageLoaded(0,this.image,this.title.innerHTML,this.title.readAttribute("href"), this.content.innerHTML);

    setTimeout(this.loadImages.bind(this), 100);
  },
  imageLoaded: function(index,image,title,link,content) {
    if( index ) {
      var anchor = document.createElement("a");
      anchor.setAttribute("href", link);
      anchor.appendChild( image );
      $("dl-media").insert(anchor,{position:'after'});
      //image = $("dl-media").select("img").last();
    }
    this.items.push( { title: title, link: link, content: content, image: image } );
  },
  loadImages: function() {
    var preloadItem = this.preload[this.loader];

    var title   = preloadItem.down("a").readAttribute("title");
    var link    = preloadItem.down("a").readAttribute("href");
    var content = preloadItem.down("cite").innerHTML;

    var image = new Image();

    image.src = preloadItem.down("ins").innerHTML;
    image.style.display = "none";

    // wait for the image to load
    try {
      image.observe("load", this.imageLoaded.bind(this,this.loader,image,title,link,content));
    }catch(e) {
      this.imageLoaded(this.loader, image, title, link, content);
    }

    this.loader++;
    if( this.preload.length > this.loader ) { setTimeout(this.loadImages.bind(this), 100); }
    else {
      this.timer = setTimeout(this.rotate.bind(this,null),7000); // all loaded start rotating
    }
  },
  rotate: function(jump) {
    var next = (this.current + 1);
    if( jump || jump == 0 ) {
      next = jump;
      if( this.fade ) { this.fade.cancel(); }
      if( this.appear ) { this.appear.cancel(); }
      if( this.timer ) { clearTimeout(this.timer); }
    }
    if( next == this.current ) { return; }

    if( next >= this.items.length ) {
      next = 0;
    }

    var currItem = this.items[this.current];
    var nextItem = this.items[next];

    // fade the images in and out
    this.fade   = new Effect.Fade(currItem.image,{duration:1.5,afterFinish:function(){ this.fade = null; }.bind(this) });
    this.appear = new Effect.Appear(nextItem.image,{duration:1.5,afterFinish:this.onAppear.bind(this,nextItem) });

    // toggle selected class
    $(this.preload[this.current]).removeClassName("selected");
    $(this.preload[next]).addClassName("selected");

    this.current = next;
  },
  onAppear: function(item) {
    this.appear = null;
    this.title.update(item.title);
    this.title.writeAttribute("href", item.link);
    this.content.update(item.content);
    this.timer = setTimeout(this.rotate.bind(this,null),7000);
  },
  jump: function(e,index) {
    e.stop();
    this.rotate(index);
  }
});
