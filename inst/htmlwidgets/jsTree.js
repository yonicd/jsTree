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
      mainDiv.id = 'jstree';
      
      var searchForm = document.createElement("form");
      searchForm.id = 's';
      
      var searchInput = document.createElement("input");
      searchInput.setAttribute('type',"search");
      searchInput.id = 'q';
      
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
      expandBtn.id='expand';
      el.appendChild(expandBtn);
      
      var collapseBtn = document.createElement("button");
      var collapseText = document.createTextNode("Collapse");
      collapseBtn.appendChild(collapseText);
      collapseBtn.id='collapse';
      el.appendChild(collapseBtn);
      
      el.appendChild(mainDiv);
      
      var tree = $('#jstree').jstree({
        'core' : {
          'data' : x.data
      },
      'search': {
            "case_insensitive": true,
            "show_only_matches" : true
          },
      'plugins': ['search','checkbox','themes']
      });
      
    $('#expand').bind("click", function () {
        $('#jstree').jstree("open_all");
    });
    $('#collapse').bind("click", function () {
        $('#jstree').jstree("close_all");
    });
    
    $("#s").submit(function(e) {
      e.preventDefault();
      $("#jstree").jstree(true).search($("#q").val());
    });

    
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});