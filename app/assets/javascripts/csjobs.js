function isAlphaNumeric(theChar) {
    if ((theChar < 48) || (theChar > 122) || 
       ((theChar > 57) && (theChar < 65)) || 
       ((theChar > 90) && (theChar < 97))   ) {
        return false;
    } else {
        return true;
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

            var curTagList = $("#job_posting_tags").attr('value');
            if(curTagList == "[]") {
                $("#job_posting_tags").attr('value', newtagtext);
            } else {
                $("#job_posting_tags").attr('value', curTagList + ";" + newtagtext);
            }

            $("span.removetag").click(function() {
                var parent = $(this).parent();
                $(this).remove();
                var tagtext = $.trim(parent.html());
                parent.remove();
                
                var curtags = $("#job_posting_tags").attr('value');
                var newtags = curtags.replace(tagtext, '').replace(";;", ";");
                $("#job_posting_tags").attr('value', newtags);
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
    $("#job_posting_description")
        .keypress(function(evt) {
            var key = evt.which;
            if(isAlphaNumeric(key)) {
                curword = curword + String.fromCharCode(key).toLowerCase();
            } else {
                curword = "";
            }
                                    
            var arrayIndex = $.inArray(curword, taglist);
            if(arrayIndex != -1) {
                $("<div class=\"token\">" + taglistOrig[arrayIndex] + " <span class=\"removetag\">x</span></div>").appendTo("#taglist");
                var curTagList = $("#job_posting_tags").attr('value');
                if(curTagList == "[]") {
                    $("#job_posting_tags").attr('value', taglistOrig[arrayIndex]);
                } else {
                    $("#job_posting_tags").attr('value', curTagList + ";" + taglistOrig[arrayIndex]);
                }
                $("span.removetag").click(function() {
                    var parent = $(this).parent();
                    $(this).remove();
                    var tagtext = $.trim(parent.html());
                    parent.remove();
                    
                    var curtags = $("#job_posting_tags").attr('value');
                    var newtags = curtags.replace(tagtext, '').replace(";;", ";");
                    $("#job_posting_tags").attr('value', newtags);
                });
            }
        });
});

function notification_display() {
    $(".notice")
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
            "border-radius" : "5px"
        })
        .delay(500)
        .fadeIn("fast")
        .delay(7000)
        .fadeOut("slow");
}
