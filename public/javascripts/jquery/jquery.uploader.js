(function($) {

$.widget("ui.uploader", {

	_init: function() {
    this.form = this.element;
    this.uuid = this.form.attr('action').replace(/^.*.X-Progress-ID=/,'');
    var namespace = this.form.attr('id');
    var self = this;
    
    var iframe = $(document.createElement('iframe'));
    iframe
      .attr('name', namespace + '-frame')
      .attr('id', namespace + '-frame')
      .attr('src', '#')
      .attr('style', 'visiblity:hidden;width:0px;height:0px;display:none');
    this.iframe = iframe;
      
    this.form
      .append(iframe)
      .append('<div class="progress-dialog" style="display:none" title="Uploading..."><div class="progressbar"></div></div>')
      .attr('target', iframe.attr('name'))
      .submit(function(event) {
        self._start();
      });
      
    this.progressbar = this.form.find('.progressbar');
    this.progressbar.progressbar();

    this.started = false;
    this.size = 0;
    this.rest = 0;

    this.interval_time = 250;
    this.intervals = [];
    this.avg_interval = 0; // keep a record of the average interval
    this.max_interval = 10; // keep the intervals limited to this value and factor in the avg_interval for weight
    this.start_time = new Date(); // transfer start time
    this.interval_count = 0;
	},

	destroy: function() {
		this.element
			.removeData("uploader")
			.unbind(".uploader");
      
		$.widget.prototype.destroy.apply(this, arguments);

	},
	
	_start: function() {
	  var self = this;
	  
    this.form.find('.progress-dialog').dialog({
      bgiframe : true,
      width    : 300,
      height   : 200,
      modal    : true,
      autoOpen : true
    });
    
    if (!this.options.valid || (this.options.valid && (typeof this.options.valid) == 'function')) {
      this.interval = setTimeout( function(){ self._fetch(); }, this.interval_time );  
    }
	},
	
  _fetch: function() {
    var self = this;
    $.ajax({
      method     : 'GET',
      url        : this.options.progressUrl,
      dataType   : 'json',
      beforeSend : function(request) {
        request.setRequestHeader("X-Progress-ID", self.uuid);
      },
      success: function(data) { self._report(data); }
    });
  },
  
  _report: function(upload) {
    
    var self = this;
    
    if (!this.started) {
      this.started = true;
    }
    
    if ((upload.state == 'done' && upload.size != undefined) || upload.state == 'uploading') {
      this.intervals.push(upload.received - this.rest);
      
      if (this.size != 0 && upload.size != this.size) { 
        this.interval = setTimeout( function(){self._fetch();}, this.interval_time );
        return;
      }
      
      this.size = upload.size;
      this.rest = upload.received;
      
      this.progressbar.progressbar('value', 100* (upload.received / upload.size));
      
      this.interval_count++;
      if (this.intervals.length > 20) {
        this.intervals = this.intervals.splice(1,this.intervals.length);
      }
      
      var it_bytes_per_second = this.intervals[this.intervals.length-1] / this.interval_time;
      
      var avg_bytes_per_second = this.rest / ((new Date().getTime() - this.start_time.getTime()) * 1000.0);
      
      var weight = this.interval_count / this.intervals.length;
      
      var recents_weight = 0;
      var sum = 0;
      for( var i = 0; i < this.intervals.length; ++i ) {
        sum += i * this.intervals[i];
        recents_weight += i;
      }
      recents_weight = sum / recents_weight;
      var transfer_rate = (recents_weight * 3) / (3 + weight);
      
      var bytes_to_send = (this.size-this.rest);
      var remaining_time = bytes_to_send / transfer_rate;
      if (remaining_time > 60) {
        remaining_time /= 60;
        say_time = " minutes remaining";
      } else {
        say_time = " seconds remaining";
      }
      
      this.interval = setTimeout( function(){self._fetch();}, this.interval_time );
    } else if (upload.state == 'starting') {
      
      this.interval = setTimeout( function(){self._fetch();}, this.interval_time );
      return;
    }
    
    if (upload.state == 'error' && upload.status == 302) {
      clearTimeout(this.interval);
      this.progressbar.progressbar('value', 100);
      // var loc = $('#uploadframe')[0].contentDocument.location.href;
      
      // <% if redirect %>
      // // window.location = "<%= admin_assets_path %>";
      // <% else %>
      // 
      // $('#progress').dialog('close');
      // <% end %>
      return;
    }
    else if( upload.state == 'done' ) {

    }
    // we are done, stop the interval
    if (upload.state == 'done' || upload.state == 'error') {
      clearTimeout(this.interval);
    }
  },

	value: function(newValue) {
		arguments.length && this._setData("value", newValue);
		return this._value();
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

$.extend($.ui.uploader, {
	version: "1.0",
	defaults: {
    uuid: null
	}
});

})(jQuery);