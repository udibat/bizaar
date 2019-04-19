$(document).ready(function() {
  $('.home-toolbar').on('click', '.filter-title-btn', function(event) {
    event.preventDefault();
    var dropdownList = $(this).siblings('.filter-dropdown');
    dropdownList.toggle();
  });
});