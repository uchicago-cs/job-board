// Non-alphanumberic characters that should not behave as punctuation and trigger a new word event when auto-tagging posting descriptions
var alphaNumericExceptions = new Array(35, 43, 47); // '#', '+', '/'

// Placeholde text in tag editing field
var placeholder = "Type a tag name and press enter"

// Determine whether a character should be interpreted as the end of a previous word when auto-tagging posting descriptions
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

$(document).ready(function() {
  var curword = "";
  var taglistdiv = document.getElementById('globaltaglist');
  if(taglistdiv) {
    taglistdiv.innerHTML = taglistdiv.innerHTML.substr(0, taglistdiv.innerHTML.length - 1);
    var taglistOrig = taglistdiv.innerHTML.split(";");
    var taglist = taglistdiv.innerHTML.toLowerCase().split(";");
  }

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

  initPlaceholder();
  $('#taglist_editable').live('click', function() {
    removePlaceholder();
  }).live('focus', function() {
    removePlaceholder();
    $(this).keypress(function(evt) {
      var key = evt.which;
      if(key == 13) { // Enter
        var tagtext = $(this).html();
        if(tagtext != "") {
          newTag(tagtext);
          $(this).html('');
        }
        return false;
      }
    });
  }).live('blur', function() {
    initPlaceholder();
  }).autocomplete({
    source: taglistOrig,
    position: {my: "left+10 top"},
    select: function(event, ui) {
      newTag(ui.item.label);
      $('#taglist_editable').empty();
      return false;
    }
  });

  $('.removetag').live('click', function(evt) {
    $(this).parent().parent().remove();
    evt.stopPropagation();
  });
  $('#taglist_static').click(function() {
    removePlaceholder();
    $('#taglist_editable').focus();
  });

  $("#posting_description").keypress(function(evt) {
    var key = evt.which;
    if(isAlphaNumeric(key)) {
      curword = curword + String.fromCharCode(key).toLowerCase();
    } else if(curword != "") {
      var arrayIndex = $.inArray(curword, taglist);
      if(arrayIndex != -1) {
        newTag(taglistOrig[arrayIndex]);
      }
      curword = "";
    }
  });

  $("form").has("#taglist").submit(function() {
    var tags = [];
    $("#taglist_static .tokentext").each(function() {
      tags.push($(this).html());
    });
    $("#posting_tags").attr('value', tags.join(';'));
    return true;
  });

  initSortable();
});

function newTag(tagtext) {
  var tag = $("<div><div class=\"token\"><span class=\"tokentext\">" + tagtext + "</span></div></div>");
  tag.find(".token").append(" <span class=\"removetag\">x</span>");
  tag.appendTo("#taglist_static");
}
    
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
        "z-index" : "11"
      })
      .delay(500)
      .fadeIn("fast")
      .delay(7000)
      .fadeOut("slow");
  }
}

function initPlaceholder() {
  if($('#taglist_editable').html() == "") {
    $('#taglist_editable').addClass('placeholder').html(placeholder);
  }
}

function removePlaceholder() {
  if($('#taglist_editable').html() == placeholder) {
    $('#taglist_editable').removeClass('placeholder').html('');
  }
}

function initSortable() {
  var sorted_none = $("<img src='/assets/sort_none.png'>");
  var sorted_up = $("<img src='/assets/sort_up.png'>");
  var sorted_down = $("<img src='/assets/sort_down.png'>");
  $(".sorted-none").append(sorted_none);
  $(".sorted-ascending").append(sorted_down);
  $(".sorted-descending").append(sorted_up);

  $(".sorted-none img").click(function() {
    window.location = "/employers?sort=" + $(this).parent().attr("data-name") + "&order=asc";
  });
  $(".sorted-ascending img").click(function() {
    window.location = "/employers?sort=" + $(this).parent().attr("data-name") + "&order=desc";
  });
  $(".sorted-descending img").click(function() {
    window.location = "/employers?sort=" + $(this).parent().attr("data-name") + "&order=asc";
  });
}
