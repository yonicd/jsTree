#' @importFrom htmlwidgets JS
customMenu <- function(){
  htmlwidgets::JS("function ($node,x) {
                  console.log(x.uri);
                  var tree = $('.jstree' + el.id).jstree(true);
                  /*var ID = $($node).attr('id');
                  
                  if (ID == 'j1_1') {
                  return items = {};
                  }
                  var $mynode = $('#' + ID);
                  var renameLabel;
                  var deleteLabel;
                  var folder = false;
                  
                  if ($mynode.hasClass('jstree-closed') || $mynode.hasClass('jstree-open')) { 
                  //If node is a folder
                  folder = true;
                  } else {
                  previewFile = 'Preview File';
                  }*/
                  
                  var items = {
                  'Create': {
                  'label': 'Create',
                  'action': function (data) {
                  var ref = $.jstree.reference(data.reference);
                  sel = ref.get_selected();
                  if(!sel.length) { return false; }
                  sel = sel[0];
                  sel = ref.create_node(sel, {'type':'file'});
                  if(sel) {
                  ref.edit(sel);
                  }
                  }
                  },
                  'Rename': {
                  'label': 'Rename',
                  'action': function (data) {
                  var inst = $.jstree.reference(data.reference);
                  obj = inst.get_node(data.reference);
                  inst.edit(obj);
                  }
                  },                         
                  'Delete': {
                  'label': 'Delete',
                  'action': function (data) {
                  var ref = $.jstree.reference(data.reference),
                  sel = ref.get_selected();
                  if(!sel.length) { return false; }
                  ref.delete_node(sel);
                  }
                  },
                  'Preview': {
                  'label': 'Preview',
                  'action': function(data,x){
                  var ref = $.jstree.reference(data.reference),
                  sel = ref.get_selected();
                  if(!sel.length) { return false; }
                  
                  var node=$('.jstree' + el.id).jstree('get_selected', true);
                  
                  if(x.uri&&x.vcs!='svn'){
                  var root_text=$('.jstree' + el.id).jstree(true).get_node('ul > li:first').text;
                  pathtofile=$('.jstree' + el.id).jstree().get_path(node[0], '/').replace(root_text,'');
                  previewDiv.appendChild(previewPre);
                  container.appendChild(previewDiv);
                  el.appendChild(container);
                  var uri=x.uri+ pathtofile + '?raw=true';
                  textP.nodeValue=uri;
                  $('.qprev'+el.id).on('input',mark);
                  
                  loadXMLDoc(uri,previewCallback);
                  }
                  }
                  }
                  };
                  
                  return items;
}")
}