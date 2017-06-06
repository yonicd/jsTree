HTMLWidgets.widget({

  name: 'jsTree',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        // Wipe the existing tree and create a new one.
      mobileConsole.show();
      
      mobileConsole.options({
    		showOnError: false,
    		proxyConsole: true,
    		isCollapsed: true,
    		catchErrors: true
    	});
      
      $elem = $('#' + el.id);
      $elem.css('overflow', 'auto');
      $elem.css('width', '100%');
      
      $elem.jstree('destroy');
      
      $('.navBar' + el.id).detach();
      $('.container' + el.id).detach();
      
      
      var navBar = document.createElement("nav");
      navBar.className = 'navBar' + el.id;
      var container = document.createElement("article");
      container.className = 'container' + el.id;
      
      var mainDiv = document.createElement("div");
      mainDiv.className = 'jstree' + el.id;
      
      var btnsDiv = document.createElement("div");
      
      var searchForm = document.createElement("form");
      searchForm.className = 's' + el.id;
      
      var searchInput = document.createElement("input");
      searchInput.setAttribute('type',"search");
      searchInput.className = 'q' + el.id;
      
      //var searchBtn = document.createElement("BUTTON");
      //var searchText = document.createTextNode("Search");
      //searchBtn.setAttribute('type',"submit");
      //searchBtn.appendChild(searchText);
      
      searchForm.appendChild(searchInput);
      //searchForm.appendChild(searchBtn);
      
      var expandBtn = document.createElement("BUTTON");
      var expandText = document.createTextNode("Expand");
      expandBtn.appendChild(expandText);
      expandBtn.className='expand' + el.id;
      
      var collapseBtn = document.createElement("BUTTON");
      var collapseText = document.createTextNode("Collapse");
      collapseBtn.appendChild(collapseText);
      collapseBtn.className='toCollapse' + el.id;
      
      var getBtn = document.createElement("BUTTON");
      var getText = document.createTextNode("Preview File");
      getBtn.appendChild(getText);
      getBtn.className='get' + el.id;
      
      
      var previewDiv = document.createElement("DIV");
      var previewPre = document.createElement("PRE");
      previewPre.id='preview' + el.id;
      
      //var br = document.createElement('BR');
      
      btnsDiv.appendChild(expandBtn);
      btnsDiv.appendChild(collapseBtn);
      if(x.uri) btnsDiv.appendChild(getBtn);
      
      navBar.appendChild(searchForm);
      //navBar.appendChild(br);
      navBar.appendChild(btnsDiv);
      navBar.appendChild(mainDiv);
      
      el.appendChild(navBar);
      
      $(".q" + el.id).on('keyup.ns.search', search);
      
      var treePlugins=['search','checkbox'];
      
      if(x.uri) treePlugins.push('contextmenu');
      
      var tree = $('.jstree' + el.id).jstree({
        'core' : {
          'data' : x.data
      },
      /*'search': {
            "case_sensitive": true,
            "show_only_matches" : true,
            "show_only_matches_children" : true
          },
      */
      'contextmenu': {'items': customMenu},
      'plugins': treePlugins
      }).on("search.jstree", function(ev, data){ //http://jsfiddle.net/2kwkh2uL/2188/
    data.nodes.children("a").each(function (idx, node) {
        var h = node.innerHTML;        
        var orig = $('.jstree').jstree(true).get_node(node).text;
        var txt = orig.replace(new RegExp("(" + data.str + ")", "gi"), function(a,b){
          //debugger;
            return '<span style="color:green">' + b + '</span>';
        });
        node.innerHTML = h.replace(new RegExp(orig, 'gi'), txt);
    });
}).on("clear_search.jstree", function(ev, data){
    $.each(data.nodes, function (idx, node) {
        var h = node.innerHTML;
        var orig = $('.jstree').jstree(true).get_node(node.id).text;
        h = h.replace(new RegExp('<span style="color:green">(.*)</span>', 'gi'),     function (a, b) {
            return b; 
        });
        node.innerHTML = h;
    });
})
.on("changed.jstree", function (ev, data) {

  //var i, j, nodes = [];
  //for(i = 0, j = data.selected.length; i < j; i++) {
  //    nodes.push(data.instance.get_node(data.selected[i]).text);
  //}
  var node=$('.jstree').jstree("get_selected", true);
  var nodes=node.map(function(n){return $('.jstree').jstree().get_path(n, '/')});

  if(typeof(Shiny) !== "undefined"){
      Shiny.onInputChange(el.id + "_update",{
        ".current_tree": JSON.stringify(nodes)
      });
  }
   
})
.on("loaded.jstree",function(ev,data){
  
  $('.jstree').jstree('select_node', 'j1_1');
});


function search(){
    var str = $(".q" + el.id).val();
    $('.jstree').jstree(true).search(str);    
}

$(".s").submit(function(e) {
  e.preventDefault();
  $('.jstree').jstree(true).search($(".q" + el.id).val());
});
      
    $('.expand' + el.id).bind("click", function () {
        $('.jstree').jstree("open_all");
    });
    $('.toCollapse' + el.id).bind("click", function () {
        $('.jstree').jstree("close_all");
    });

var titleP = document.createElement('P');
var textP = document.createTextNode('');
titleP.appendChild(textP);
previewDiv.appendChild(titleP);


$(".get" + el.id).click(function () {
var node=$('.jstree').jstree("get_selected", true);

if(x.uri){
        var uri=x.uri+$('.jstree').jstree().get_path(node[0], '/') + '?raw=true';
        loadXMLDoc(uri);
        textP.nodeValue=uri;
        
        previewDiv.appendChild(previewPre);
        container.appendChild(previewDiv);
        el.appendChild(container);
      }

});

function loadXMLDoc(uri) {
  var xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("preview" + el.id).innerHTML =
      this.responseText;
    }
  };
  xmlhttp.open("GET", uri, true);
  xmlhttp.send();
}

  function customMenu(node) { //http://jsfiddle.net/dpzy8xjb/
        //debugger
        //Show a different label for renaming files and folders
        var tree = $('.jstree').jstree(true);
        var ID = $(node).attr('id');
        if (ID == "j1_1") {
            return items = {};
        }
        var $mynode = $('#' + ID);
        var renameLabel;
        var deleteLabel;
        var folder = false;
        if ($mynode.hasClass("jstree-closed") || $mynode.hasClass("jstree-open")) { 
          //If node is a folder
            folder = true;
        } else {
            previewFile = "Preview File";
        }
        var items = {
                "preview": {
                  "label": previewFile,
                  "action": function(obj){
                    if(x.uri){
                            var uri=x.uri+tree.get_path($(node)[0], '/') + '?raw=true';
                            loadXMLDoc(uri);
                            textP.nodeValue=uri;
                            
                            previewDiv.appendChild(previewPre);
                            container.appendChild(previewDiv);
                            el.appendChild(container);
                          }
                  }
                }
        };

        return items;
    }
    
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});