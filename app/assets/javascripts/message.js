$(document).on('turbolinks:load', function(){

  function buildHTML(message){
    var image = message.image.url ? `<img class="lower-message__image" src= ${message.image.url} >` : "";
    var html = `<div class="message" data-message-id="${message.id}">
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
    .done(function(message){
      var html = buildHTML(message);
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
  
  setInterval(function(){
    last_message_id = $('.message:last').data("message-id");
      if($(".main-header__edit-btn")[0]){
      // if (document.URL.match(/\/groups\/\d+\/messages/)){
      // if (document.URL.match("/messages")){                    （メモ）3行全て同じ動き
        $.ajax({
          url: 'api/messages',
          type: 'GET',
          dataType: 'json',
          data: {id: last_message_id}
        })
        .done(function(messages){
          messages.forEach(function(message){
            var insertHTML = buildHTML(message);
            $('.messages').append(insertHTML);
            $('.messages').animate({ scrollTop: $('.messages')[0].scrollHeight});
          });
        })
        .fail(function(){
          alert('error');
        });  
      };
  }, 5000);
});