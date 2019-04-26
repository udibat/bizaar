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
    var form = $(this).parents('#homepage-filters');
    form.find('input:text, input:password, input:file, select, textarea').val('');
    form.find('input:radio, input:checkbox')
         .removeAttr('checked').removeAttr('selected');
    resetPriceRange(); 
    form.get(0).submit();
  });

  addNewOption();

  changeDropdownName();
  priceRangeChangeName();

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

function addNewOption() {
  $('.filter-dropdown').on('click', '#add_new_option', function(event) {
    event.preventDefault();
    var parent = $(this).parents('.filter-dropdown');
    var optionItem = parent.find('.option-item');
    var clonedEl = optionItem.first().clone();
    var optionContainer = parent.find('.option-container');
    var count = optionItem.length + 1;

    optionContainer.append(clonedEl);
    
    clonedEl.find('.checkbox-item').each(function(i, el) {
      var input = $(el).find('input');
      var label = $(el).find('label');

      var id = input.attr('id');
      var labelFor = label.attr('for');

      input.attr('id', id + count);
      label.attr('for', labelFor + count);
      input.prop('checked', false);
    })
  });
}

// TODO: call this function when form submit
function changeDropdownName() {
  $('.filters-holder').on('change', 'input', function(){
    var $this = $(this);
    var parent = $this.parents('.filters-holder');
    var checkLength = parent.find('input:checked').length;

    var toggleBtn = parent.find('.toggle-btn');
    var defaultText = toggleBtn.data('default');
    var selectedText = toggleBtn.data('selected');

    if(checkLength) {
      toggleBtn.text(selectedText).addClass('selected');
    } else {
      toggleBtn.text(defaultText).removeClass('selected');
    }
  })
}


function priceRangeChangeName() {
  $('.price-range-holder').on('change', '#range-slider-price', function(){
    var minPrice = parseInt($('#price_min').val());
    var maxPrice = parseInt($('#price_max').val());
    var rangeSliderMin = parseInt($('.range-slider').data('min'));
    var rangeSliderMax = parseInt($('.range-slider').data('max'));

    var $this = $(this);
    var parent = $this.parents('.price-range-holder');
    var toggleBtn = parent.find('.toggle-btn');
    var defaultText = toggleBtn.data('default');
    var selectedText = toggleBtn.data('selected');

    if(minPrice === rangeSliderMin && maxPrice === rangeSliderMax) {
      toggleBtn.text(defaultText).removeClass('selected');
    } else {
      toggleBtn.text(`$${minPrice} - $${maxPrice}`).addClass('selected');
    }
  })
}

function resetPriceRange() {
  var rangeSliderMin = $('.range-slider').data('min');
  var rangeSliderMax = $('.range-slider').data('max');
  $('#range-slider-price').val([rangeSliderMin, rangeSliderMax]);
}