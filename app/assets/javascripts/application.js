// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require_tree .
//= require jquery
//= require jquery_ujs

// application.js(Drop down menu)
$(function () {
  const SMARTPHONE = 670;
  var timer = 0; // リサイズの処理を軽くするため
  var menuIconBars = true;
  var menuIconTimes = false;

  $('.menu-icon-bars').click(function () {
    $('html, body').addClass('html-body-hidden'); // Scroll enabled
    $('.header-menus-drop-down').slideDown(400);
    $('.header-menus-overlay').fadeIn(400);
    $('.flash').hide();

    $('.menu-icon-bars').fadeToggle('fast', function () {
      $('.menu-icon-times').fadeToggle('fast');
      menuIconBars = false;
      menuIconTimes = true;
    });
    $('.header-menus-overlay').click(function () {
      $('.header-menus-drop-down').slideUp(400);
      $('.header-menus-overlay').fadeOut(400);
      $('.menu-icon-bars').show();
      $('.menu-icon-times').hide();
      $('html, body').removeClass('html-body-hidden');
      $('.flash').show();
      menuIconBars = true;
      menuIconTimes = false;
    });
  });
  $('.menu-icon-times').click(function () {
    $('html, body').removeClass('html-body-hidden'); // Scroll disabled
    $('.header-menus-drop-down').slideUp(400);
    $('.header-menus-overlay').fadeOut(400);
    $('.flash').show();

    $('.menu-icon-times').fadeToggle('fast', function () {
      $('.menu-icon-bars').fadeToggle('fast');
    });
    menuIconBars = true;
    menuIconTimes = false;
  });

  window.onresize = function () { // resize
    if (timer > 0) {
      clearTimeout(timer);
    }
    timer = setTimeout(function () {
      var windowWidth = window.innerWidth;
      if (windowWidth <= SMARTPHONE) { // Smartphone layout
        if (menuIconBars) {
          $('.menu-icon-bars').show();
          $('.header-menus').hide();
          $('.header-menus-drop-down').hide();
        } else if (menuIconTimes) {
          $('.menu-icon-times').show();
          $('.header-menus').hide();
          $('.header-menus-drop-down').show();
          $('.flash').hide();
        }
      } else if (SMARTPHONE <= windowWidth) { // Layouts other than smartphones
        $('.menu-icon-bars').hide();
        $('.menu-icon-times').hide();
        $('.header-menus').show();
        $('.flash').show();
      }
    }, 100);
  };
});

// app/views/posts/new.html
$(function () {
  if ($('input[name="star"]:checked').val() == null) {
    var evaChange = 0;
  } else {
    var evaChange = $('input[name="star"]:checked').val();
  }
  $('input').click(function () {
    var star = $('input[name="star"]:checked').val();
    if (evaChange <= star) {
      for (var i = 1; i <= star; i++) {
        $(`.eva${i}`).css('color', 'gold');
        $(`.eva${i}`).addClass('star-spin');
      }
      evaChange = i;
    } else if (evaChange > star) {
      for (var i = 5; i > star; i--) {
        $(`.eva${i}`).css('color', 'rgb(192, 192, 192)');
        $(`.eva${i}`).removeClass('star-spin');
      }
      evaChange = i;
    }
  })
});

// modal
$(function () {
  $('.show-modal-1, .show-modal-2').click(function () {
    $('.confirm-modal-overlay').fadeIn("fast");
    $('.confirm-modal').fadeIn("fast");
  });
  $('.show-modal-delete').click(function () {
    $('.confirm-modal-overlay').fadeIn("fast");
    $('.confirm-modal-delete').fadeIn("fast");
  });
  $('.show-modal-edit').click(function () {
    $('.confirm-modal-overlay').fadeIn("fast");
    $('.confirm-modal-delete').fadeIn("fast");
  });
  $('.show-modal-account-delete').click(function () {
    $('.confirm-modal-overlay').fadeIn("fast");
    $('.confirm-modal-account-delete').fadeIn("fast");
  });
  $('.close-modal').click(function () {
    $('.confirm-modal-overlay').fadeOut("fast");
    $('.confirm-modal').fadeOut("fast");
    $('.confirm-modal-delete').fadeOut("fast");
    $('.confirm-modal-account-delete').fadeOut("fast");
  });
  $('.confirm-modal-overlay').click(function () {
    $('.confirm-modal-overlay').fadeOut("fast");
    $('.confirm-modal').fadeOut("fast");
    $('.confirm-modal-delete').fadeOut("fast");
    $('.confirm-modal-account-delete').fadeOut("fast");
  });
  $('.modal-btn-reject').click(function () {
    $('.confirm-modal-overlay').fadeOut("fast");
    $('.confirm-modal').fadeOut("fast");
    $('.confirm-modal-delete').fadeOut("fast");
    $('.confirm-modal-account-delete').fadeOut("fast");
  });
});

// Double transmission prevention
$(function () {
  $('a, button').click(function () {
    $('.overlay').show();
  });
});