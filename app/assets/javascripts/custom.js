$(document).ready(function() {
  $('.home-toolbar').on('click', '.filter-title-btn', function(event) {
    event.preventDefault();
    var parent = $(this).parent();
    var $body = $('body');

    parent.toggleClass('active').siblings().removeClass('active');

    if(parent.hasClass('active')) {
      $body.addClass('opened');
    } else {
      $body.removeClass('opened');
    }
  });

  $('.home-toolbar').on('click', '.more-options-btn', function(event) {
    event.preventDefault();
    var parent = $(this).parent();
    var resultContainer = $('.search-result-container');

    parent.toggleClass('active');

    if(parent.hasClass('active')) {
      resultContainer.addClass('opened');
    } else {
      resultContainer.removeClass('opened');
    }
  });

});

$(window).on('scroll', function() {
  (function () {
    var homeMap = $('#home-map');

    function isInViewport (el) {
      var elementTop = $(el).offset().top;
      var elementBottom = elementTop + $(el).outerHeight();

      var viewportTop = $(window).scrollTop();
      var viewportBottom = viewportTop + $(window).height();

      return elementBottom > viewportTop && elementTop < viewportBottom;
    };

    if (homeMap.length) {
      var offsetTopMap = $('.custom-map-desktop').offset().top;
      var scrollTopWindow = $(this).scrollTop();

      if (scrollTopWindow >= offsetTopMap) {
        homeMap.addClass('fixed');
      } else {
        homeMap.removeClass('fixed');
      }

      if (isInViewport('.custom-footer')) {
        homeMap.removeClass('fixed');
      }
    }
  })();
});
