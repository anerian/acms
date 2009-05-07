(function($){   
  $.fn.imagePicker = function(options) {
    options = $.extend({}, options || {});
    return this.each(function() {      
      new ImagePicker(this, options);
    });
  };

  $.fn.imagePickerOpen = function(options) {
    options = $.extend({}, options || {});
    return this.each(function() {
      new ImagePicker(this, options).open();
    });
  };
  
  function ImagePicker(element, options) {
    this.element   = $(element);
    this.namespace = this.element.attr('id');
    this.imagesUrl = options.imagesUrl;
    
    this.wrapper    = $('#' + this.namespace + "_wrapper");
    this.content   = $('#' + this.namespace + "_content");
    this.loader    = this.wrapper.find('.image_picker_loader');
    this.pager     = this.content.find('.pagination a');
    this.replace   = this.element.find('img');
    this.cache     = {};
    this.mutex     = false;
    this.opened    = false;
    this.input     = options.input;
    this.selected  = options.selected;
    
    this.dialog = this.wrapper.dialog({
      bgiframe: true,
      width  : 510,
      height : 540,
      modal  : true,
      autoOpen : false,
      buttons: {
				Cancel: function() {
					$(this).dialog('close');
				}
			}
    });
    
    var that = this;
    
    this.element.click(function(event) {        
      event.preventDefault();
      that.open();
    });
  }
  
  ImagePicker.prototype = {
    open: function() {
      try {
      this.wrapper.dialog('open');

      if (this.opened) return;
      this.opened = true;
      
      this.loader.show();
      this.content.fadeOut(1000);

      this.mutex = true;
      var that = this;
      $.get(this.imagesUrl, function(data){
        that.mutex = false;
        that.onDataLoaded(data);
      });
      
      this.observePagination();
      
      this.element.opened = true;
      } catch(e) { 
        console.error(e);
      }
    },
    onDataLoaded: function(data) {
      this.content.html(data);
      this.observePagination();
      
      this.loader.hide();
      this.content.show();
    },
    
    observePagination: function() {
      var that = this;
      
      this.content.find('.thumbs a img').click(function(event){
        event.preventDefault();
        
        that.replace.attr('src', $(this).attr('src'));
        var id = $(this).attr('id');
        if (that.input) that.input.attr('value', id);
        if (that.selected) that.selected(id);
        that.wrapper.dialog('close');
      });
      this.content.find('.pagination a').click(function(event){
        var link = this;
        event.preventDefault();
        
        if (that.mutex) return;
        that.mutex = true;
        
        that.loader.show();
        that.content.fadeOut(500, function() {
          $.get($(link).attr('href'), function(data){ 
            that.onDataLoaded(data);
            that.mutex = false;
          });
        });
      });
    }
  };
})(jQuery);
