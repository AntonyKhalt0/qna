$(function() {
  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      this.perform('follow', { question_id: gon.question_id });
    },
    
    received: function(data) {
      resource = `.${data['resource']}-${data['id']}-comments`;
      $(`${resource} .comments`).append(data['message']);
      $(`${resource} #comment_body`).val('');
    }
  })
})
