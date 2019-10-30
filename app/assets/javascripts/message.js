$(function(){
  function buildHTML(message){
    var image = (message.image ? `<img class="lower-message__image" src="${message.image}">` : "");
    var html = `<div class="message">
                 <div class="upper-message">
                   <div class="upper-message__user-name">
                   ${message.name}
                   </div>
                   <div class="upper-message__date">
                   ${message.date}
                   </div>
                 </div>
                 <div class="lower-message">
                   <p class="lower-message__content">
                   ${message.content}
                   </p>
                 </div>
                 ${image}
               </div>`
    return html;
  }


  $('.new-message').on('submit', function(e){
    e.preventDefault();
    var formData = new FormData(this);
    var url = $(this).attr('action')
    $.ajax({
      url: url,
      type: "POST",
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
    })
    .done(function(data){
      var html = buildHTML(data);
      $('.messages').append(html)
      $('.new-message')[0].reset();
      $('.submit-btn').removeAttr('disabled');
      $('.messages').animate({ scrollTop: $('.messages')[0].scrollHeight});
    })
    .fail(function(){
      alert('error');
    })
    // .always(() => {
    //   $(".submit-btn").removeAttr("disabled");
    // });                                          メモ $('.submit-btn').removeAttr('disabled');の代用の3行
  })
}) 