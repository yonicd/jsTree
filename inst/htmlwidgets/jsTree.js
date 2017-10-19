HTMLWidgets.widget({

  name: 'jsTree',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

      mobileConsole.hide();
      
      mobileConsole.options({
    		showOnError: false,
    		proxyConsole: true,
    		isCollapsed: true,
    		catchErrors: true
    	});
      
        $elem = $('#' + el.id);
        
      // css definitions
        $elem.css('overflow', 'auto');
        $elem.css('width', '100%');
      
      // Wipe the existing old elements
        $elem.jstree('destroy');
        $('.navBar' + el.id).detach();
        $('.container' + el.id).detach();
      
      // initiate DOM elements
        var navBar       = document.createElement("nav");
        var container    = document.createElement("article");
        var mainDiv      = document.createElement("DIV");
        var btnsDiv      = document.createElement("DIV");
        var searchForm   = document.createElement("form");
        
        var searchInput  = document.createElement("input");
        var searchInputPreview  = document.createElement("input");
        
        var expandBtn    = document.createElement("BUTTON");
        var collapseBtn  = document.createElement("BUTTON");
        var getBtn       = document.createElement("BUTTON");
        var previewDiv   = document.createElement("DIV");
        var previewPre   = document.createElement("PRE");
        var titleP       = document.createElement('P');
        
        var expandText   = document.createTextNode("Expand");
        var collapseText = document.createTextNode("Collapse");
        var getText      = document.createTextNode("Preview File");
        var textP        = document.createTextNode('');

      
      // add attributes
        navBar.className      = 'navBar' + el.id;
        container.className   = 'container' + el.id;
        mainDiv.className     = 'jstree' + el.id;
        searchForm.className  = 's' + el.id;
        
        searchInput.setAttribute('type',"search");
        searchInput.className = 'q' + el.id;
        
        searchInputPreview.setAttribute('type',"text");
        searchInputPreview.setAttribute('placeholder',"Search in text");
        searchInputPreview.className = 'qprev' + el.id;
        
        
        
        expandBtn.className   = 'expand' + el.id;
        collapseBtn.className = 'toCollapse' + el.id;
        getBtn.className      = 'get' + el.id;
        previewPre.id         = 'preview' + el.id;
      
      //attach elements to navbar
                  searchForm.appendChild(searchInput);
                  expandBtn.appendChild(expandText);
                  collapseBtn.appendChild(collapseText);
                  getBtn.appendChild(getText);
                  btnsDiv.appendChild(expandBtn);
                  btnsDiv.appendChild(collapseBtn);
        if(x.uri&&x.vcs!='svn') btnsDiv.appendChild(getBtn);
                  navBar.appendChild(searchForm);
                  navBar.appendChild(btnsDiv);
                  navBar.appendChild(mainDiv);
                  el.appendChild(navBar);
      
      //attach elements to preview container
                  titleP.appendChild(textP);
                  previewDiv.appendChild(titleP);
                  previewDiv.appendChild(searchInputPreview);
  
      //define the tree plugins
        var treePlugins=['search','checkbox'];
        if(x.uri&&x.vcs!='svn') treePlugins.push('contextmenu');
  
      //create the tree    
      var tree = $('.jstree' + el.id).jstree({
        'core' : {
          'data' : x.data
      },
      'contextmenu': {'items': customMenu},
      'plugins': treePlugins,
      'search': {
            "case_sensitive": false,
            "show_only_matches": false
       }
      })
        .on("changed.jstree", function(ev, data) {
        
          //var i, j, nodes = [];
          //for(i = 0, j = data.selected.length; i < j; i++) {
          //    nodes.push(data.instance.get_node(data.selected[i]).text);
          //}
          var node=$('.jstree' + el.id).jstree("get_selected", true);
          var nodes=node.map(function(n){return $('.jstree' + el.id).jstree().get_path(n, '/')});
        
          if(typeof(Shiny) !== "undefined"){
              Shiny.onInputChange(el.id + "_update",{
                ".current_tree": JSON.stringify(nodes)
              });
          }
           
          })
        .on("loaded.jstree", function(ev,data) {
          
          $('.jstree' + el.id).jstree('select_node', x.openwith);
          });

      //attach search function to tree
        $('.q' + el.id).keyup(function () {
                var searchString = $(this).val();
                $('.jstree' + el.id).jstree('search', searchString);
        });

      //attach function of expand and collapse to buttons
        $('.expand' + el.id).bind("click", function() {
            $('.jstree' + el.id).jstree("open_all");
        });
        $('.toCollapse' + el.id).bind("click", function() {
            $('.jstree' + el.id).jstree("close_all");
        });
      
      //attach get function to preview button
        $(".get" + el.id).click(function() {
      var node=$('.jstree' + el.id).jstree("get_selected", true);
        if(x.uri&&x.vcs!='svn'){
          var root_text=$('.jstree' + el.id).jstree(true).get_node('ul > li:first').text;
          pathtofile=$('.jstree' + el.id).jstree().get_path(node[0], '/').replace(root_text,'');
          previewDiv.appendChild(previewPre);
          container.appendChild(previewDiv);
          el.appendChild(container);

          var uri=x.uri+ pathtofile + '?raw=true';
          textP.nodeValue=uri;
          $('.qprev'+el.id).on("input",mark);
          
          loadXMLDoc(uri,previewCallback);
        }
            
      });

    function previewCallback(data){
      document.getElementById("preview" + el.id).innerHTML = data;
      if(x.forcekey){
        $('.qprev'+el.id).val(x.forcekey);
        $('.qprev'+el.id).trigger('input');
      }
      
    }
      
      //function to retrieve files from remote addresses
        function loadXMLDoc(uri,callback) {
          var xmlhttp = new XMLHttpRequest();
          xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
              callback(this.responseText);
            }
          };
          xmlhttp.open("GET", uri, true);
          xmlhttp.send();
        }

      //custom menu function (http://jsfiddle.net/dpzy8xjb/)
        function customMenu(node) {
          var tree = $('.jstree' + el.id).jstree(true);
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
                      if(x.uri&&x.vcs!='svn'){
                              var root_text=$('.jstree' + el.id).jstree(true).get_node('ul > li:first').text;
                              var pathtofile=tree.get_path($(node)[0], '/').replace(root_text,'');

                              previewDiv.appendChild(previewPre);
                              container.appendChild(previewDiv);
                              el.appendChild(container);
                              
                              var uri=x.uri + pathtofile + '?raw=true';
                              textP.nodeValue=uri;
                              $('.qprev'+el.id).on("input",mark);

                              loadXMLDoc(uri,previewCallback);
                            }
                    }
                  }
          };
  
          return items;
    }

        var mark = function() {
    // Read the keyword
    var keyword = $('.qprev'+el.id).val();
    // Determine selected options
    var options = {"separateWordSearch":true,"diacritics":true,"debug":false};

    // Remove previous marked elements and mark
    // the new keyword inside the context
    $('#preview' + el.id).unmark({
      done: function() {
        $('#preview' + el.id).mark(keyword,options);
      }
    });
  };

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});