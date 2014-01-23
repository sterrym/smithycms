var ace_edit = function(id, template_type, name) {
  if (!name) { name = 'template_content' }
  var editor_name = name + '_editor-' + id
  $('#'+editor_name).show();
  var editor = ace.edit(editor_name);
  var textarea = $('textarea[id="' + name + '-'+id+'"]').hide();
  var session = editor.getSession();
  session.setMode("ace/mode/" + template_type);
  session.setValue(textarea.val());
  session.setTabSize(2);
  session.setUseSoftTabs(true);
  session.setUseWrapMode(true);
  session.on('change', function(){
    textarea.val(editor.getSession().getValue());
  });
  editor.commands.addCommand({
    name: 'save',
    bindKey: {win: 'Ctrl-S',  mac: 'Command-S'},
    exec: function(editor) {
      $("#"+editor.container.id).closest('form').submit();
    },
    readOnly: false
  });
  return editor;
}
