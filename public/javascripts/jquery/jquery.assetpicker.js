(function($) {

$.widget("ui.assetpicker", {

	_init: function() {
    this.namespace = this.element.attr('id');
    
    this.wrapper    = $('#' + this.namespace + "_wrapper");
    this.content   = $('#' + this.namespace + "_content");
    this.mutex     = false;
    
    this.dialog = this.wrapper.dialog({
      bgiframe: true,
      width  : 510,
      height : 540,
      modal  : true,
      autoOpen : true,
      buttons: {
				Cancel: function() {
					$(this).dialog('close');
				}
			}
    });
    
    var self = this;
    
    // this._trigger('selected', null, {});
    
    $("#" + this.element.attr('id') + "_wrapper .image_picker_tabs").tabs({
      collapsible: false,
      load: function(event, ui) { self._attach(ui); }
    });
	},

	destroy: function() {

		this.element
			.removeData("assetpicker")
			.unbind(".assetpicker");
      
    this.wrapper.dialog('destroy');
      
		$.widget.prototype.destroy.apply(this, arguments);

	},

	value: function(newValue) {
		arguments.length && this._setData("value", newValue);
		return this._value();
	},

  _attach: function(tabs) {
    switch (tabs.index) {
      case 0:
      case 1:
        this._attachMediaEvents(tabs.panel);
        break;
      case 2:
        this._attachForm();
        break;
    }
  },
  
  _attachMediaEvents: function(panel) {
    var self = this;
    panel = $(panel);
    panel.find('.thumbs a').click(function(event){
      event.preventDefault();
      
      self._trigger('selected', null, {
        id: $(this).find('img:first').attr('id'),
        type: $(this).attr('basic_type'),
        path: $(this).attr('href'),
        thumbPath: $(this).find('img:first').attr('src')
      });
      
      self.destroy();
    });
  },
  
  _attachVideos: function(panel) {
    
  },

	_setData: function(key, value) {

		switch (key) {
			case 'value':
				this.options.value = value;
				this._trigger('change', null, {});
				break;
		}

		$.widget.prototype._setData.apply(this, arguments);

	},

	_value: function() {

		var val = this.options.value;

		return val;

	},

	_refreshValue: function() {

	}

});

$.extend($.ui.assetpicker, {
	version: "1.0",
	defaults: {

	}
});

})(jQuery);
