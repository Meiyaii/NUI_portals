$('document').ready(function() {

  $('.frontoverlay').hide();
  $('.insideoverlay').hide();
  $('.quit').hide();

  window.addEventListener('message', function(event) {
      if (event.data.action == 'Enter') {
          $('.frontoverlay').fadeIn("slow");
      } else if (event.data.action == 'Leave') {
          $('.insideoverlay').fadeIn("slow");
      } else if (event.data.action == 'Close') {
          $('.frontoverlay').fadeOut("slow");
          $.post('http://portals/NUIFocusOff', JSON.stringify({}));
      }
  });
  document.onkeyup = function(data) {
      if (data.which == 27) {
          $('.frontoverlay').fadeOut("slow");
          $.post('http://portals/NUIFocusOff', JSON.stringify({}));
      }
  }
  document.getElementById('enter').addEventListener('click', function(event) {
      $.post('http://portals/enter', JSON.stringify({

      }));
      $('.frontoverlay').fadeOut("slow");
      $.post('http://portals/NUIFocusOff', JSON.stringify({}));
  })
  document.getElementById('close').addEventListener('click', function(event) {
      $('.frontoverlay').fadeOut("slow");
      $.post('http://portals/NUIFocusOff', JSON.stringify({}));
  })
  document.getElementById('leave').addEventListener('click', function(event) {
      $.post('http://portals/leave', JSON.stringify({

      }));
      $('.insideoverlay').fadeOut("slow");
      $.post('http://portals/NUIFocusOff', JSON.stringify({}));
  })
});