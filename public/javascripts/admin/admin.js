$.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script;

$(document).ajaxSend(function(event, request, settings) {  
  if (typeof(AUTH_TOKEN) == "undefined") return;
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

// controls for the toolbar
// persist's the toolbar state using cookies
function ToolBar() {
  var navItems = ['pages', 'links', 'media', 'appearance', 'users', 'tools', 'settings'];
  for( var i = 0, len = navItems.length; i < len; ++i ) {
    var state = $.cookie(navItems[i]);
    //console.log("check: "+ navItems[i] + "=" + state);
    if( state == 'hidden' ) {
      //console.log("hide it");
      var icon = $("#toolbar ." + navItems[i] + "-icon");
      var h2 = icon.parents("h2");
      h2.next("ul").hide();
      h2.parent().removeClass("open");
    }
  }
  $("#toolbar h2 .handle").click(function(e) {
    e.preventDefault();
    var item = $(this).parents("h2").children(".micon").get(0);
    var options = { path: '/', expires: 10 };
    var itemName = null;

    for( var i = 0, len = navItems.length; i < len; ++i ) {
      if( item.className.match(navItems[i]) ) {
        itemName = navItems[i];
        break;
      }
    }
    var h2 = $(this).parents("h2");
    var ul = h2.next("ul");
    // show the line below the header right away
    if( ul.get(0).style.display == "none" ) {
      $.cookie(itemName, "visible", options);
      h2.parent().addClass("open");
    }
    ul.slideToggle("fast", function() {
      if( $(this).get(0).style.display == 'none' ) {
        // delay showing this line until the sub-menu is fully appeared
        $.cookie(itemName, "hidden", options);
        h2.parent().removeClass("open");
      }
    });
  });
}

// Controls the ActionBar drop down
function ActionBar() {
  var changing = false;
  $("#fav-actions .toggle").mouseenter( function() {
    if( !changing && $("#fav-actions .menu").css("display") == 'none' && !$("#fav-actions").hasClass("open") ) {
      $("#fav-actions").addClass("open");
      changing = true;
      $("#fav-actions .menu").slideToggle("fast", function() {
        //visible = true;
        changing = false;
      });
    }
  });
  $("#fav-actions").mouseleave( function() {
    if( !changing && $("#fav-actions .menu").css("display") == 'block' && $("#fav-actions").hasClass("open") ) {
      changing = true;
      $("#fav-actions .menu").slideToggle("fast", function() {
        $("#fav-actions").removeClass("open");
        //visible = false;
        changing = false;
      });
    }
  });
}

$(document).ready(function () {
  ToolBar();
  ActionBar();
});
