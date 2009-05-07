Editor = Class.create({
  initialize: function(element) {
    this.id = $(element).id;

    var editor = this;

    tinyMCE.init({
      mode : "mode",
      theme : "advanced",
      skin: "wp_theme",
      plugins : "media",
      theme_advanced_buttons1 : "bold,italic,underline,separator,strikethrough,justifyleft,justifycenter,justifyright,justifyfull,bullist,numlist,undo,redo,link,unlink,more_tag,media",
      theme_advanced_buttons2 : "",
      theme_advanced_buttons3 : "",
      theme_advanced_toolbar_location : "top",
      theme_advanced_toolbar_align : "left",
      setup: function( ed ) {
        try {

        var more_tag = "Insert More tag";
        var moreHTML = '<img src="/images/widgets/trans.gif" class="mceWPmore mceItemNoResize" title="'+more_tag+'" />';

        ed.addCommand('More_tag', function() {
          ed.execCommand('mceInsertContent', 0, moreHTML);
        });

        ed.addButton("more_tag", {
          title: more_tag,
          image: "/images/widgets/more.gif",
          cmd: "More_tag",
          //onclick: editor.insertMoreTag.bindAsEventListener(editor)
        });

        ed.addShortcut("alt+shift+t", more_tag, 'More_Tag');

        // Replace morebreak with images
        ed.onBeforeSetContent.add(function(ed, o) {
          o.content = o.content.replace(/<!--more-->/g, moreHTML);
        });

        // Replace images with morebreak
        ed.onPostProcess.add(function(ed, o) {
          if (o.get)
            o.content = o.content.replace(/<img[^>]+>/g, function(im) {
              if (im.indexOf('class="mceWPmore') !== -1) {
                im = '<!--more-->'; //"'
              }
              return im;
            });
        });

        // Set active buttons if user selected pagebreak or more break
        ed.onNodeChange.add(function(ed, cm, n) {
          cm.setActive('wp_more', n.nodeName === 'IMG' && ed.dom.hasClass(n, 'mceWPmore'));
        });


        }catch(e) {
          alert(e);
        }
      }
    });
  },
  toggle: function()
  {
    var cmd = ( tinyMCE.getInstanceById(this.id) == null ) ? 'mceAddControl' : 'mceRemoveControl';
    tinyMCE.execCommand( cmd, false, this.id );
  },
  setContent: function( content )
  {
    var editor = tinyMCE.getInstanceById(this.id);
    editor.setContent( content );
  },
  getContent: function()
  {
    return tinyMCE.getInstanceById(this.id).getContent();
  },
  bindControls: function(control)
  {
    var controls = control.down(".toolbar").select("li");
    for( var i = 0, len =controls.length; i < len; ++i ) {
      var anchor = controls[i].down("a");
      anchor.observe("click", function(ev,e) {
        ev.stop();
        if( this.up("li").className == "active" ){ return; } // do nothing if we're active
        e.toggle();
        // remove classes
        this.up("ul").select("li").each( function(li) { li.className = ""; });
        this.up("li").className = "active";
      }.bindAsEventListener(anchor, this) );
    }
  }
});
