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
      
      el.appendChild(mainDiv);
      
      var tree = $('#jstree').jstree({
        'core' : {
          'data' : x.data
      },plugins: ['checkbox','search','contextmenu','themes','types']
        
      });
      
    

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});