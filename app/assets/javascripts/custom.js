function display_rating(dom) {
    dom.find(".stars[data-rating]").each(function(){
        var starOn = $('#raty_star_on').data('url'),
            starOff = $('#raty_star_off').data('url'),
            starHalf = $('#raty_star_half').data('url');
        var opts = {
            readOnly: !$(this).data('target'),
            half: true,
            path: '',
            score: parseFloat($(this).data('rating')),
            starOn: starOn,
            starOff: starOff,
            starHalf: starHalf,
        };

        if (!opts.readOnly) {
            opts.target = $(this).data('target');
            opts.targetType = 'number';
            opts.targetKeep = true;
        }
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

  $('.custom-select-holder > select, .custom-select').select2({
    minimumResultsForSearch: -1,
    placeholder: function(){
      $(this).data('placeholder');
    }
  });

  wordsCounter('#custom_profile_description, #person_description, .update_profile_description_text_area');


  $('.settings-form form').find('textarea, input, select').attr('disabled', 'disabled');
  $('.settings-form form').find('button, a:not(".link")').addClass('disabled');
  $('.settings-form').find('.form-element').addClass('disabled');

  $('.settings-form').on('click', '.edit-settings-button', function(e) {
    e.preventDefault();
    var $this = $(this);
    var parent = $this.parents('div');
    parent.find('textarea, input, select').attr('disabled', false);
    parent.find('button, a').removeClass('disabled');
    parent.find('.form-element').removeClass('disabled');
  })

  // Install input filters.

  $(".numeric-input").inputFilter(function(value) {
    return /^\d*$/.test(value); });

  $('.payment-date-input').on('input', function(event) {
    var value = event.currentTarget.value
    var cleanValue = value.replace('/', '')
    var reg = new RegExp('^[0-9]+$');
    
    if (cleanValue.length && !reg.test(+cleanValue)){
      $(this).val('')
      return false
    }
  })

  $('.payment-date-input').on('keyup', function(event) {
    var value = event.currentTarget.value
    
    var key = event.keyCode || event.charCode;
    if( key == 8 || key == 46 )
          return true;
    
    if (value && value.length === 2) {
      value += '/'
    }
    
    $(this).val(value)
  })

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

    var textToSelect = '$' + minPrice + '- $' + maxPrice; 

    if(minPrice === rangeSliderMin && maxPrice === rangeSliderMax) {
      toggleBtn.text(defaultText).removeClass('selected');
    } else {
      toggleBtn.text(textToSelect).addClass('selected');
    }
  })
}

function resetPriceRange() {
  var rangeSliderMin = $('.range-slider').data('min');
  var rangeSliderMax = $('.range-slider').data('max');
  $('#range-slider-price').val([rangeSliderMin, rangeSliderMax]);
}

function wordsCounter(textarea) {
  var textarea = $(textarea);
  var countBlock = $('.written-char');

  if(textarea.length !== 0) {
    var textCount = textarea.val().length;
    countBlock.text(textCount);
    textarea.on('keyup', function(event) {
      var countVal = $(this).val().length;
      $(this).parents('div').find(countBlock).text(countVal);
    });
  }
}

function clickOutside(element) {
  $(document).mouseup(function(e) {
    var container = $(element);

    if (!container.is(e.target) && container.has(e.target).length === 0) {
        container.fadeOut();
    }
  });
}

$(function() {

    $(".light-slider").lightSlider({
        item: 1,
        loop: true,
        pager: false,
        enableDrag: false,
    });


});

function checkPhotosNumber(photoItem) {
  var item = $(photoItem);

  if(item.length === 10) {
    // console.log(item.length)
    $('.upload-link').hide();
  } else {
    $('.upload-link').show();

  }
}

// Restricts input for each element in the set of matched elements to the given inputFilter.
(function($) {
  $.fn.inputFilter = function(inputFilter) {
    return this.on("input keydown keyup mousedown mouseup select contextmenu drop", function() {
      if (inputFilter(this.value)) {
        this.oldValue = this.value;
        this.oldSelectionStart = this.selectionStart;
        this.oldSelectionEnd = this.selectionEnd;
      } else if (this.hasOwnProperty("oldValue")) {
        this.value = this.oldValue;
        this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
      }
    });
  };
}(jQuery));

