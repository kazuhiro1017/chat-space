$(document).on('turbolinks:load', function (){
  
  function addUser(user){
    var html = `
              <div class="chat-group-user clearfix">
                <p class="chat-group-user__name">${user.name}</p>
                <a class="user-search-add chat-group-user__btn chat-group-user__btn--add" data-user-id="${user.id}" data-user-name="${user.name}">追加</a>
              </div>
              `;
    $("#user-search-result").append(html);
  }

  function addNoUser(){
    var html = `
              <div class="chat-group-user clearfix">
                <p class="chat-group-user__name">ユーザーが見つかりません</p>
              </div>
              `;
    $("#user-search-result").append(html);
  }

  function addDeleteUser(name, userId) {
    let html = `
    <div class="chat-group-user clearfix" id="${userId}">
      <p class="chat-group-user__name">${name}</p>
      <a class="user-search-remove chat-group-user__btn" data-user-id="${userId}" data-user-name="${name}">削除</a>
    </div>`;
    $(".js-add-user").append(html);
  }

  function addMember(userId) {
    let html = `<input class="user-id" value="${userId}" name="group[user_ids][]" type="hidden" id="group_user_ids_${userId}" />`;
    $(`#${userId}`).append(html);
  }


  
  var userIds =[]
  
  function builduserIds(){
    $(".user-id").map(function(){
      let userId = $(this).val();
      userIds.push(userId)
    })
  }
  
  function emptyofarray(){
    userIds = [];
  }
  
  builduserIds();
  
  
  $("#user-search-field").on("keyup", function(){
    let input = $("#user-search-field").val();
    
    $.ajax({
      type: 'GET',
      url: '/users',
      data: { keyword: input, userIds: userIds },
      dataType: 'json'
    })

    .done(function(users){
      $("#user-search-result").empty();
      
      if (users.length !== 0){
        users.forEach(function(user){
          addUser(user);
        });
      }
      else if (input.length == 0){
        return false;
      }
      else{
        addNoUser();
      }
    })
    .fail(function(){
      alert("error");
    });
  });


  $("#user-search-result").on("click", ".user-search-add", function() {
    const userName = $(this).attr("data-user-name");
    const userId = $(this).attr("data-user-id");
    $(this).parent().remove();
    addDeleteUser(userName, userId);
    addMember(userId);
    emptyofarray();
    builduserIds();
  });

  $(document).on("click", ".user-search-remove", function() {
    $(this).parent().remove();
    emptyofarray();
    builduserIds();
  });
});