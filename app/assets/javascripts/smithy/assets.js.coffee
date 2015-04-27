$('#assets').DataTable {
  "responsive": true,
  "serverSide": true,
  "processing": true,
  "ajax": $('#assets').attr('data-source'),
  "order": [[1, 'asc']],
  "columnDefs": [
    { "targets": [0,4], "searchable": false, "orderable": false },
    { "targets": [0], "className": "preview" }
  ]
}