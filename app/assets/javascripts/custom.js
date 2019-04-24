function display_rating(dom) {
    dom.find(".stars[data-rating]").each(function(){
        var opts = {
            readOnly: !$(this).data('target'),
            half: true,
            score: parseFloat($(this).data('rating'))
        };

        if (!opts.readOnly) {
            opts.target = $(this).data('target');
            opts.targetType = 'number';
            opts.targetKeep = true;
        }
        console.log(opts);
        $(this).raty(opts);
    });
}

$(document).ready(function() {
  display_rating($("body"));

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

  $('.change_mark').on('change', function(){
      var url = $(this).data('url'),
          member_id = $(this).data('member-id'),
          value = $(this).val();
      $.post(url, {mark: value, person_id: member_id});
  });

  $('#homepage-filters').on('click', '#clear_btn', function(event) {
    event.preventDefault();
    console.log('test');
    $(this).parents('form').get(0).reset();
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
        homeMap.removeClass('fixed').addClass('absolute');
      } else {
        homeMap.removeClass('absolute');
      }
    }
  })();
});
