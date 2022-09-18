$(function() {
  const answersList = $('.answers');

  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      this.perform('follow', { question_id: gon.question_id });
    },
    
    disconnected: function() {},
    
    received: function(data) {
      answersList.append(data);
    }
  })
})
