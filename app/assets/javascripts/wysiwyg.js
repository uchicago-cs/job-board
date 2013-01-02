$(document).ready(function() {
  $('a.richtext').live('click', function() {
    new TINY.editor.edit('editor', {
      id: 'posting_description',
      controls: ['bold', 'italic', 'underline', 'strikethrough', '|', 'subscript', 'superscript', '|', 'orderedlist', 'unorderedlist', '|' ,'outdent' ,'indent', '|', 'leftalign', 'centeralign', 'rightalign', 'blockjustify', '|', 'unformat', '|', 'undo', 'redo', 'n', /*'font',*/ 'size', 'style', '|', 'hr', 'link', 'unlink'],
      cssfile: '/assets/tinyeditor.css',
      cssclass: 'tinyeditor',
      rowclass: 'tinyeditor-header',
      controlclass: 'tinyeditor-control',
      dividerclass: 'tinyeditor-divider',
      footer: true,
      //fonts: ['Verdana', 'Arial', 'Georgia', 'Trebuchet MS', 'Times New Roman'],
      css: 'body {background-color: #fff}',
      toggle: {text: 'source', activetext: 'wysiwyg', cssclass: 'toggle'},
      resize: {cssclass:'resize'}
    });
    $(this).html('[Plain Text]').removeClass('richtext').addClass('plaintext');
    $("#posting_rich_description").attr('value', 't');

    $('#new_posting').submit(function() {
      editor.post();
      return true;
    });
  });

  $('a.plaintext').live('click', function() {
    editor.post();
    $('#posting_description').insertAfter('div.tinyeditor').attr('style', '');
    $('div.tinyeditor').remove();
    delete editor 
    $(this).html('[Rich Text]').removeClass('plaintext').addClass('richtext');
    $("#posting_rich_description").attr('value', '');
  });

  if($("#posting_rich_description").attr('value') == "t") {
    $('a.richtext').trigger('click');
  }
});
