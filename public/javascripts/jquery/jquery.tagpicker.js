(function($){   
  $.fn.tagPicker = function(options) {
    options = $.extend({}, options || {});
    return this.each(function() {      
      new TagPicker(this, options);
    });
  };
  
  function TagPicker(element, options) {
    this.element = $(element);
    this.id = this.element.attr('id');
    this.input = $('#'+this.id+'_entry');
    this.button = $('#'+this.id+'_button');
    this.container = $('#'+this.id+'_container');
    this.checklist = this.container.find('.tagchecklist');
    this.tags = [];

    this.add(this.element.attr('value'));
    
    var that = this;
    this.button.click(function(event){
      that.add(that.input.attr('value'));
    });
  }
  
  TagPicker.prototype = {
    add: function(csv) {
      var newTags = this.filter(csv);

      var that = this;
      for (var i = 0; i < newTags.length; i++) {
        var html = '<span><a title="' + newTags[i] + '" class="ntdelbutton" id="post_tag-check-num-0"> </a> ';
        html += newTags[i];
        html += '</span>';
        this.checklist.append(html);
        this.checklist.find('.ntdelbutton:last').click(function(event){
          event.preventDefault();
          that.delete($(this));
        });
      }
      
      this.tags = this.tags.concat(newTags);
      this.input.attr('value', '');
      
      this.synchronize();
    },
    
    delete: function(anchor) {
      var tag = anchor.attr('title');
      
      anchor.parent().remove();
      if (jQuery.inArray(tag, this.tags) > -1) {
        this.tags.splice(jQuery.inArray(tag, this.tags),1);
      }
      
      this.synchronize();
    },
    
    filter: function(csv) {
      var tags = csv.split(',');
      var filtered = [];
      for (var i = 0; i < tags.length; i++) {
        var tag = jQuery.trim(tags[i]);
        if (tag != '' && jQuery.inArray(tag, this.tags)) filtered.push(tag);
      }
      return filtered;
    },
    
    synchronize: function() {
      this.element.attr('value', this.tags.join(', '));
    } 
  };
})(jQuery);