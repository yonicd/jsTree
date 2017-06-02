HTMLWidgets.widget({

  name: 'jsTree',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        // Wipe the existing tree and create a new one.
      $elem = $('#' + el.id);
      
      $elem.jstree('destroy');
      
      $('#' + el.id).css('overflow', 'auto');
      $('#' + el.id).css('width', '100%');
      
      var navBar = document.createElement("nav");
      var container = document.createElement("article");
      
      var mainDiv = document.createElement("div");
      mainDiv.className = 'jstree';
      
      var btnsDiv = document.createElement("div");
      
      var searchForm = document.createElement("form");
      searchForm.className = 's';
      
      var searchInput = document.createElement("input");
      searchInput.setAttribute('type',"search");
      searchInput.className = 'q';
      
      //var searchBtn = document.createElement("BUTTON");
      //var searchText = document.createTextNode("Search");
      //searchBtn.setAttribute('type',"submit");
      //searchBtn.appendChild(searchText);
      
      searchForm.appendChild(searchInput);
      //searchForm.appendChild(searchBtn);
      
      var expandBtn = document.createElement("BUTTON");
      var expandText = document.createTextNode("Expand");
      expandBtn.appendChild(expandText);
      expandBtn.className='expand';
      
      var collapseBtn = document.createElement("BUTTON");
      var collapseText = document.createTextNode("Collapse");
      collapseBtn.appendChild(collapseText);
      collapseBtn.className='collapse';
      
      var getBtn = document.createElement("BUTTON");
      var getText = document.createTextNode("Get");
      getBtn.appendChild(getText);
      getBtn.className='get';
      
      
      var previewDiv = document.createElement("DIV");
      var previewPre = document.createElement("PRE");
      previewPre.id='preview';
      
      var br = document.createElement('BR');
      
      btnsDiv.appendChild(expandBtn);
      btnsDiv.appendChild(collapseBtn);
      btnsDiv.appendChild(getBtn);
      
      navBar.appendChild(searchForm);
      navBar.appendChild(br);
      navBar.appendChild(btnsDiv);
      navBar.appendChild(mainDiv);
      
      el.appendChild(navBar);
      
      $(".q").on('keyup.ns.search', search);
      
      var tree = $('.jstree').jstree({
        'core' : {
          'data' : x.data
      },
      /*'search': {
            "case_sensitive": true,
            "show_only_matches" : true,
            "show_only_matches_children" : true
          },
      */
      'plugins': ['search','checkbox']
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
});

function search(){
    var str = $(".q").val();
    $(".jstree").jstree(true).search(str);    
}

$(".s").submit(function(e) {
  e.preventDefault();
  $(".jstree").jstree(true).search($(".q").val());
});
      
    $('.expand').bind("click", function () {
        $('.jstree').jstree("open_all");
    });
    $('.collapse').bind("click", function () {
        $('.jstree').jstree("close_all");
    });

$(".get").click(function () {
console.log($('.jstree').jstree(true).get_selected());
console.log($('.jstree').jstree().get_selected(true)[0].text);

if(x.uri){
        var uri=x.uri+$('.jstree').jstree().get_selected(true)[0].text + '?raw=true';
        loadXMLDoc(uri);
        
        var headerP = document.createElement('header');
        var titleP = document.createElement('P');
        var textP = document.createTextNode(uri);
        titleP.appendChild(textP);
        //headerP.appendChild(titleP);
        
        previewDiv.appendChild(titleP);
        previewDiv.appendChild(previewPre);
        container.appendChild(previewDiv);
        el.appendChild(container);
      }

});

function loadXMLDoc(uri) {
  var xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("preview").innerHTML =
      this.responseText;
    }
  };
  xmlhttp.open("GET", uri, true);
  xmlhttp.send();
}

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});