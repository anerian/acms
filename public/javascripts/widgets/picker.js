/*
  Proto!MultiSelect 0.2
  - Prototype version required: 6.0
  
  Credits:
  - Idea: Facebook
  - Guillermo Rauch: Original MooTools script
  - Ran Grushkowsky/InteRiders Inc. : Porting into Prototype and further development
  
  Changelog:
  - 0.1: translation of MooTools script
  - 0.2: renamed from Proto!TextboxList to Proto!MultiSelect, added new features/bug fixes
        added feature: support to fetch list on-the-fly using AJAX    Credit: Cheeseroll
        added feature: support for value/caption
        added feature: maximum results to display, when greater displays a scrollbar   Credit: Marcel
        added feature: filter by the beginning of word only or everywhere in the word   Credit: Kiliman
        added feature: shows hand cursor when going over options
        bug fix: the click event stopped working
        bug fix: the cursor does not 'travel' when going up/down the list   Credit: Marcel
*/

/* Copyright: InteRiders <http://interiders.com/> - Distributed under MIT - Keep this message! */

var FacebookList = Class.create(TextboxList, { 
  
  loptions: $H({    
    autocomplete: {
      'opacity': 0.8,
      'maxresults': 10,
      'minchars': 1
    }
  }),
  
  initialize: function($super,element, autoholder, options, func) {
    $super(element, options);
    this.data = [];    
    this.autoholder = $(autoholder).setOpacity(this.loptions.get('autocomplete').opacity); 
    
    this.autoholder.observe('mouseover',function() {this.curOn = true;}.bind(this)).observe('mouseout',function() {this.curOn = false;}.bind(this));
    this.autoresults = this.autoholder.down('ul');
    var children = this.autoresults.select('li');
    children.each(function(el) { this.add({value:el.readAttribute('value'),caption:el.innerHTML}); }, this); 
  },
  
  autoShow: function(search) {
    this.autoholder.setStyle({'display': 'block'});
    this.autoholder.descendants().each(function(e) { $(e).hide() });
    if(! search || ! search.strip() || (! search.length || search.length < this.loptions.get('autocomplete').minchars)) 
    {
      this.autoholder.select('.default').first().setStyle({'display': 'block'});
      this.resultsshown = false;
    } else {
      this.resultsshown = true;
      this.autoresults.setStyle({'display': 'block'}).update('');
      var regexp = null;
      if (this.options.get('wordMatch'))
        regexp = new RegExp("(^|\\s)"+search,'i')
      else
        regexp = new RegExp(search,'i');
      var count = 0;
      
      this.data.filter(function(str) { return str ? regexp.test(str.evalJSON(true).caption) : false; }).each(function(result, ti) {
        count++;
        if(ti >= this.loptions.get('autocomplete').maxresults) return;
        var that = this;
        var el = new Element('li');
        el.observe('click',function(e) { 
            e.stop();
            that.autoAdd(this); 
        }).observe('mouseover',function() { 
            that.autoFocus(this);
        }).update(this.autoHighlight(result.evalJSON(true).caption, search));
        this.autoresults.insert(el);
        el.cacheData('result', result.evalJSON(true));
        if(ti == 0) this.autoFocus(el);
      }, this);
    }
    if (count > this.options.get('results'))
        this.autoresults.setStyle({'height': (this.options.get('results')*24)+'px'});
    else
        this.autoresults.setStyle({'height': (count?(count*24):0)+'px'});
    return this;
  },
  
  autoHighlight: function(html, highlight) {
    return html.gsub(new RegExp(highlight,'i'), function(match) {
      return '<em>' + match[0] + '</em>';
    });
  },
  
  autoHide: function() {    
    this.resultsshown = false;
    $(this.autoholder).hide();    
    return this;
  },
  
  autoFocus: function(el) {
    if(! el) return;
    if(this.autocurrent) this.autocurrent.removeClassName('auto-focus');
    this.autocurrent = el.addClassName('auto-focus');
    return this;
  },
  
  autoMove: function(direction) {    
    if(!this.resultsshown) return;
    this.autoFocus(this.autocurrent[(direction == 'up' ? 'previous' : 'next')]());
    this.autoresults.scrollTop = this.autocurrent.positionedOffset()[1]-this.autocurrent.getHeight();         
    return this;
  },
  
  autoFeed: function(text) {
    if (this.data.indexOf(Object.toJSON(text)) == -1)
        this.data.push(Object.toJSON(text));
    return this;
  },
  
  autoAdd: function(el) {
    if(!el || ! el.retrieveData('result')) return;
    this.add(el.retrieveData('result'));
    delete this.data[this.data.indexOf(Object.toJSON(el.retrieveData('result')))];
    this.autoHide();
    var input = this.lastinput || this.current.retrieveData('input');
    input.clear().focus();
    return this;
  },
  
  createInput: function($super,options) {
    var li = $super(options);
    var input = li.retrieveData('input');
    input.observe('keydown', function(e) {
        this.dosearch = false;
        switch(e.keyCode) {
          case Event.KEY_UP: e.stop(); return this.autoMove('up');
          case Event.KEY_DOWN: e.stop(); return this.autoMove('down');        
          case Event.KEY_RETURN:
            e.stop();
            if(! this.autocurrent) break;
            this.autoAdd(this.autocurrent);
            this.autocurrent = false;
            this.autoenter = true;
            break;
          case Event.KEY_ESC: 
            this.autoHide();
            if(this.current && this.current.retrieveData('input'))
              this.current.retrieveData('input').clear();
            break;
          default: this.dosearch = true;
        }
    }.bind(this));
    input.observe('keyup',function(e) {
        
        switch(e.keyCode) {
          case Event.KEY_UP: 
          case Event.KEY_DOWN: 
          case Event.KEY_RETURN:
          case Event.KEY_ESC: 
            break;              
          default: 
                if (!Object.isUndefined(this.fetchFile)) {
                  new Ajax.Request(this.fetchFile, {
                    parameters: {keyword: input.value},
                    onSuccess: function(transport) {
                        transport.responseText.evalJSON(true).each(function(t){this.autoFeed(t)}.bind(this));
                        this.autoShow(input.value);
                    }.bind(this)
                  });        
                }
                else
                    if(this.dosearch) this.autoShow(input.value);          
        }        
    }.bind(this));

    input.observe(Prototype.Browser.IE ? 'keydown' : 'keypress', function(e) { 
      if(this.autoenter) e.stop();
      this.autoenter = false;
    }.bind(this));
    return li;
  },
  
  createBox: function($super,text, options) {
    var li = $super(text, options);
    li.observe('mouseover',function() { 
        this.addClassName('bit-hover');
    }).observe('mouseout',function() { 
        this.removeClassName('bit-hover') 
    });
    var a = new Element('a', {
      'href': '#',
      'class': 'closebutton'
      }
    );
    a.observe('click',function(e) {
          e.stop();
          if(! this.current) this.focus(this.maininput);
          this.dispose(li);
    }.bind(this));
    li.insert(a).cacheData('text', Object.toJSON(text));
    return li;
  }
  
});

/* allow only a single selection */
var RemoteAutoSingleList = Class.create(FacebookList, { 
  add: function(text, html) {
    var input = this.lastinput || this.current.retrieveData('input');
    var picked = $pick(html,text);
    input.value = picked.caption;

    if( this.onInputComplete ) {
      this.onInputComplete( picked );
    }

    return input;
  },
  autoAdd: function(el) {
    if(!el || ! el.retrieveData('result')) return;
    this.add(el.retrieveData('result'));
    delete this.data[this.data.indexOf(Object.toJSON(el.retrieveData('result')))];
    this.autoHide();
    //var input = this.lastinput || this.current.retrieveData('input');
    //input.clear().focus();
    return this;
  }
});

Element.addMethods({
    onBoxDispose: function(item,obj) { obj.autoFeed(item.retrieveData('text').evalJSON(true)); },
    onInputFocus: function(el,obj) { obj.autoShow(); },    
    onInputBlur: function(el,obj) { 
        obj.lastinput = el;
        if(!obj.curOn) {
            obj.blurhide = obj.autoHide.bind(obj).delay(0.1);
        }
    },
    filter:function(D,E){var C=[];for(var B=0,A=this.length;B<A;B++){if(D.call(E,this[B],B,this)){C.push(this[B]);}}return C;}
});  

var TagList = Class.create(FacebookList, {
  initialize: function($super, element, autoholder, data_url, options) {
    //if( !options.className ) { options.className = element; }
    $super(element, autoholder, options);
    new Ajax.Request(data_url, { method: "GET", onSuccess: this.loadData.bind(this) });
    if( options && options.suggested && options.text_for_suggest ) {
      $(element + '_suggest').observe('click', this.suggested.bindAsEventListener(this) );
      this.suggested = options.suggested;
      this.text_for_suggest = options.text_for_suggest;
    }
  },
  loadData: function(request) {
    var data = window.eval( "(" + request.responseText + ")" );
    if (data) { this.data = data.map(function(t) { return t.name; }); }
  },
  setSuggested: function(request) {
    try{
    var data = request.responseJSON;
    if( !data ) { return ; }
    this.clear();
    for( var i = 0; i < data.length; ++i ) {
      this.add(data[i].name);
    }
    this.update();
    }catch(e){ Sick.debug(e); }
  },
  suggested: function(e) {
    e.stop();
    try {
    var text = ""
    if( typeof(this.text_for_suggest) == "object" && this.text_for_suggest.length > 0 ) {
      for( var i = 0, len = this.text_for_suggest.length; i < len; ++i ) {
        text += " " + $(this.text_for_suggest[i]).innerHTML.replace(/[^\w]/g," ");
      }
    }
    else if( typeof(this.text_for_suggest) == "function" ) {
      text = this.text_for_suggest.call();
    }
    else {
      // assume it's a string
      text = $(this.text_for_suggest).innerHTML.replace(/[^\w]/g," ");
    }
    new Ajax.Request(this.suggested, { parameters:{text:text}, onSuccess: this.setSuggested.bind(this) });
    }catch( e ) {
      Sick.debug( e );
    }
  }
});

// in single mode, select image button, goes from a toggle to an insert image callback
var ImagePicker = Class.create({
  initialize: function(input_id, widget_id, url, single) {
    this.single             = single;
    // save some inputs
    this.results            = $(input_id);
    this.widget             = $(widget_id).up(".carousel_widget");
    this.assets_url         = url;
    this.observing          = {};

    // collect DOM elements
    this.carousel_element   = this.widget.down(".horizontal_carousel");
    this.filterBox          = this.widget.down(".filter");
    this.filterInput        = this.filterBox.down("input");
    this.filterAction       = this.filterBox.select("input").last();
    this.selectedImage      = this.widget.down(".selected_image");
    if( !this.selectedImage ) {
      // user wants multi select - look for selected_files class intead
      this.selectionBox = this.widget.down(".selected_files");
      this.selectionBox.select("li").each( function(li) {
        var asset_id = li.readAttribute("asset_id");
        li.down("input").observe("click",this.removeItem.bindAsEventListener(this,li, asset_id) );
      }.bind(this));
    }

    // create the UI element
    this.picker             = new UI.Ajax.Carousel(this.carousel_element, {url: this.assets_url, elementSize:150 } );
 
    // hide some components, only if we're not in single mode
    if( !this.single ) { this.off(); }
    
    // hide some components
    this.off();

 
    // watch for some events
    this.curSize = this.picker.elements.size();
    this.widget.down(".picker").observe("click", this.toggle.bindAsEventListener(this) );
    this.picker.observe("request:ended", this.attach.bind(this) );
    this.picker.observe("request:started", this.reportRequest.bind(this) );
    this.filterInput.observe("focus", function(e) { if(this.filterInput.value == 'Filter text'){ this.filterInput.value = ''; } }.bindAsEventListener(this));
    this.filterInput.observe("blur", function(e) { if(this.filterInput.value == ''){ this.filterInput.value = 'Filter text'; } }.bindAsEventListener(this));
    this.filterAction.observe("click", this.filter.bindAsEventListener(this) );
  },
  reportRequest: function(e) {
    //console.debug("requesting");
  },
  attach: function(e) {
    if( this.picker.elements.size() == this.curSize ) {
      if( this.interval ) { clearInterval(this.interval); }
      this.interval = setInterval( this.attach.bind(this,"again"), 0.5 );
    }
    else {
      if( this.interval ) { clearInterval(this.interval); }
      this.curSize = this.picker.elements.size();
      this.picker.elements.each( function(li) {
        var asset_id = li.readAttribute("asset_id");
        if( !this.observing[asset_id] ) { 
          li.observe("click", this.select.bindAsEventListener(this,asset_id) );
          this.observing[asset_id] = true;
        }
      }.bind(this) );
    }
  },
  removeItem: function(e,item, asset_id) {
    // remove from the list and update the this.results
    var ids = this.results.value.split(",").collect( function(id) {
      return id.strip(); // strip whitespace for comparison
    } ).reject( function(id) {
      return id == asset_id; // locate the id we're deleteing
    } );
    this.results.value = ids.join(", ");
    // finally remove the list item
    item.remove();
    e.stop();
  },
  select: function(e,id) {
    // get the image src
    var li = this.picker.elements.find( function(li) {
      return( li.readAttribute("asset_id") == id );
    } );
    var src = li.down("img").readAttribute("src");

    // it's a single select picker
    if( this.selectedImage ) {
      if( this.single ) {
        this.single(src);
      }
      else {
        // show the resulting image
        this.selectedImage.update("<img src='" + src + "'/>");
        this.widget.down(".picker").value = "Replace Image";
      }
      // save the result id
      this.results.value = id;
    }
    else {
      // it's multiple selection so we need to add the new item to the list and attach it's event handlers
      var li = $(document.createElement("li"));
      li.writeAttribute("asset_id",id); // add the asset_id attribute
      li.update("<img src='" + src + "'/><input type='button' value='Remove'/>");
      li.down("input").observe("click", this.removeItem.bindAsEventListener(this,li,id) );
      this.selectionBox.appendChild(li);
      this.results.value += ", " + id;
      this.results.value = this.results.value.replace(/^,\s*/,''); // incase we're the first added
    }
    this.toggle(e);
  },
  filter: function(e) {
    e.stop();
    var text = this.filterInput.value;
    // clear out existing elements
    this.picker.container.select("li").each( function(li) { li.remove(); } );
    this.picker.elements = [];
    this.curSize = 0;
    this.observing = {};
    // send the request, with the extra keyword param
    this.picker.runRequest.bind(this.picker).defer({parameters:
        {keyword: text, from: 0, to: Math.ceil(this.picker.nbVisible) - 1},
         onSuccess: this.picker.updateHandler});
  },
  toggle: function(e) {
    e.stop();
    if( this.carousel_element.visible() ) {
      this.off();
    }
    else {
      this.on();
    }
  },
  on: function() {
    this.carousel_element.show();
    this.filterBox.show();
  },
  off: function() {
    if( !this.single ) { 
      this.carousel_element.hide();
      this.filterBox.hide();
      this.results.hide();
    }
  }
});
