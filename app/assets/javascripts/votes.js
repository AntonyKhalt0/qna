$(document).on('turbolinks:load', function(){
  $('.votes').on('ajax:success', function(e) {
    let resource = e.detail[0].resource;
    let id = e.detail[0].id;
    let rating = e.detail[0].rating;

    $('#rating-' + id + '-' + resource).html(rating);
  })
    .on('ajax:error', function(e) {
      let resource = e.detail[0].resource;
      let id = e.detail[0].id;
      let errors = e.detail[0].errors;
      
      $.each(errors, function(index, value) {
        $('#errors-' + id + '-' + resource).html('<p>' + value + '</p>');
      })
    })
});
