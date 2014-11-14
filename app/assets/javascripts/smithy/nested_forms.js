/*
  Nested Forms
*/
$(function() {
  $('form').on('click', 'a.add_nested_fields', function() {
    // Setup
    var assoc   = $(this).attr('data-association');           // Name of child
    var content = $('#' + assoc + '_fields_blueprint').html(); // Fields template

    // Make the context correct by replacing new_<parents> with the generated ID
    // of each of the parent objects
    var context = ($(this).parents('.fields').children('input:first').attr('name') || '').replace(new RegExp('[[a-z]+]$'), '');

    // context will be something like this for a brand new form:
    // project[tasks_attributes][1255929127459][assignments_attributes][1255929128105]
    // or for an edit form:
    // project[tasks_attributes][0][assignments_attributes][1]
    if(context) {
      var parent_names = context.match(/[a-z]+_attributes/g) || []
      var parent_ids   = context.match(/[0-9]+/g)

      for(i = 0; i < parent_names.length; i++) {
        if(parent_ids[i]) {
          content = content.replace(
            new RegExp('(\[' + parent_names[i] + '\])\[.+?\]', 'g'),
            '$1[' + parent_ids[i] + ']'
          )
        }
      }
    }

    // Make a unique ID for the new child
    var regexp  = new RegExp('new_' + assoc, 'g');
    var new_id  = new Date().getTime();
    content     = content.replace(regexp, new_id)

    $(this).parent().append(content);
    return false;
  });

  $('form').on('click', 'a.remove_nested_fields', function() {
    var container = $(this).closest('.destroy');
    var hidden_field = $('input[type=hidden]', container).val('1');
    $(this).closest('.nested').hide();
    return false;
  });

  // replace the remover checkboxes with a link
  $('form .destroy > label').hide();
  $('form .destroy').each(function(i) {
    link = $('<a href="javascript:void(0);" class="btn btn-danger btn-mini">Delete</a>').addClass("remove_nested_fields");
    $(this).empty().append($(link));
  });

});
