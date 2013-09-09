var ace_edit = function(id, template_type) {
  $('#template_content_editor-'+id).show();
  var editor = ace.edit('template_content_editor-'+id);
  var textarea = $('textarea[id="template_content-'+id+'"]').hide();
  // textarea.closest('.control-group').hide();
  editor.getSession().setMode("ace/mode/" + template_type);
  editor.getSession().setValue(textarea.val());
  editor.getSession().setTabSize(2);
  editor.getSession().setUseSoftTabs(true);
  editor.getSession().setUseWrapMode(true);
  editor.getSession().on('change', function(){
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
  return this;
}
