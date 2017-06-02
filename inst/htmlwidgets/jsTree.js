HTMLWidgets.widget({

  name: 'jsTree',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        // Wipe the existing tree and create a new one.
      $elem = $('#' + el.id)
      
      $elem.jstree('destroy');
      
      var mainDiv = document.createElement("div");
      mainDiv.className = 'jstree';
      
      var searchForm = document.createElement("form");
      searchForm.className = 's';
      
      var searchInput = document.createElement("input");
      searchInput.setAttribute('type',"search");
      searchInput.className = 'q';
      
      var searchBtn = document.createElement("button");
      var searchText = document.createTextNode("Search");
      searchBtn.setAttribute('type',"submit");
      searchBtn.appendChild(searchText);
      
      searchForm.appendChild(searchInput);
      searchForm.appendChild(searchBtn);
      el.appendChild(searchForm);
      
      var expandBtn = document.createElement("button");
      var expandText = document.createTextNode("Expand");
      expandBtn.appendChild(expandText);
      expandBtn.className='expand';
      el.appendChild(expandBtn);
      
      var collapseBtn = document.createElement("button");
      var collapseText = document.createTextNode("Collapse");
      collapseBtn.appendChild(collapseText);
      collapseBtn.className='collapse';
      el.appendChild(collapseBtn);
      
      var getBtn = document.createElement("button");
      var getText = document.createTextNode("Get");
      getBtn.appendChild(getText);
      getBtn.className='get';
      el.appendChild(getBtn);
      
      el.appendChild(mainDiv);
      
      /*var link = "http://www.quirksmode.org/iframetest2.html";
      
      var iframe = document.createElement('iframe');
      iframe.frameBorder=0;
      iframe.width="300px";
      iframe.height="250px";
      iframe.id="iframeId";
      iframe.setAttribute("src", link);
      el.appendChild(iframe);*/
      
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
        var txt = orig.replace(new RegExp("("+data.str + ")", "gi"), function(a,b){
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
});

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});