alphaNumericExceptions = new Array(35, 43, 47); // '#', '+', '/'

function isAlphaNumeric(theChar) {
  if ((theChar >= 48 && theChar <= 57) ||           // 0-9
      (theChar >= 65 && theChar <= 90) ||           // A-Z
      (theChar >= 97 && theChar <= 122) ||          // a-z
      ($.inArray(theChar, alphaNumericExceptions) != -1)) {  // misc. exceptions (e.g., "C++" or "C#")
    return true;
  } else {
    return false;
  }
}

function newTag() {
  $("<div class=\"token\"><span class=\"tokentext\"><i>New Tag: </i></span></div>").appendTo("#taglist");
  var tag = $(".token").last();
  var tagtextfield = tag.children('span');
  $(document).keypress(function(evt) {
    var key = evt.which;
    var taglistdiv = document.getElementById('globaltaglist');
    taglistdiv.innerHTML = taglistdiv.innerHTML.substr(0, taglistdiv.innerHTML.length - 1);
    var taglistOrig = taglistdiv.innerHTML.split(";");
    if(isAlphaNumeric(key)) {
      tagtextfield.html(tagtextfield.html() + String.fromCharCode(key));
    } else if(key == 8) { // Delete/Backspace
      tagtextfield.html(tagtextfield.html().substr(0, tagtextfield.html().length - 1));
      evt.preventDefault();
      evt.returnFalse = false;
    } else if(key == 13) { // Enter
      $(document).unbind();
      var newtagtext = tagtextfield.html().substring(16);
      tagtextfield.html(newtagtext);
      tag.append(" <span class=\"removetag\">x</span>");

      var curTagList = $("#posting_tags").attr('value');
      if(curTagList == "[]") {
        $("#posting_tags").attr('value', newtagtext);
      } else {
        $("#posting_tags").attr('value', curTagList + ";" + newtagtext);
      }

      $("span.removetag").click(function() {
        var parent = $(this).parent();
        $(this).remove();
        var tagtext = $.trim(parent.html());
        parent.remove();
                
        var curtags = $("#posting_tags").attr('value');
        var newtags = curtags.replace(tagtext, '').replace(";;", ";");
        $("#posting_tags").attr('value', newtags);
      });
    }
  });
}

$(document).ready(function() {
  notification_display();

  var i = 0;
  $(".jobtable > tbody > tr:nth-child(odd)").addClass("odd");
  $(".jobtable > tbody > tr:nth-child(even)").addClass("even");

  $(".help").mouseover(function(evt) {
    $("<div id=\"help\"></div>").prependTo("body");
    $("#help")
      .html($(this).attr('alt'))
      .css({'top': evt.pageY + 3, 'left': evt.pageX + 3});
  }).mouseout(function() {
    $("#help").remove();
  });
    
  var taglistdiv = document.getElementById('globaltaglist');
  taglistdiv.innerHTML = taglistdiv.innerHTML.substr(0, taglistdiv.innerHTML.length - 1);
  var taglistOrig = taglistdiv.innerHTML.split(";");
  var taglist = taglistdiv.innerHTML.toLowerCase().split(";");

  $("#addtag").click(newTag);
  var curword = "";
  $("#posting_description")
    .keypress(function(evt) {
      var key = evt.which;
      if(isAlphaNumeric(key)) {
        curword = curword + String.fromCharCode(key).toLowerCase();
      } else {
        var arrayIndex = $.inArray(curword, taglist);
        if(arrayIndex != -1) {
          $("<div class=\"token\">" + taglistOrig[arrayIndex] + " <span class=\"removetag\">x</span></div>").appendTo("#taglist");
          var curTagList = $("#posting_tags").attr('value');
          if(curTagList == "[]") {
            $("#posting_tags").attr('value', taglistOrig[arrayIndex]);
          } else {
            $("#posting_tags").attr('value', curTagList + ";" + taglistOrig[arrayIndex]);
          }
          $("span.removetag").click(function() {
            var parent = $(this).parent();
            $(this).remove();
            var tagtext = $.trim(parent.html());
            parent.remove();
                      
            var curtags = $("#posting_tags").attr('value');
            var newtags = curtags.replace(tagtext, '').replace(";;", ";");
            $("#posting_tags").attr('value', newtags);
          });
        }
        curword = "";
      }
    });
});

function notification_display() {
  if($(".alert").first().html() != "") {
    var notification = $(".alert");
  } else if($(".notice").first().html() != "") {
    var notification = $(".notice");
  }

  if(notification) {
    notification
      .prependTo("body")
      .css({
        "position" : "fixed",
        "top" : "20px",
        "right" : "20px",
        "width" : "auto",
        "padding" : "10px 20px 10px 20px",
        "margin" : "0",
        "border" : "0",
        "background-color" : "#cccccc",
        "display" : "none",
        "border-radius" : "5px",
        "z-index" : "10"
      })
      .delay(500)
      .fadeIn("fast")
      .delay(7000)
      .fadeOut("slow");
  }
}
