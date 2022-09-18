$(function() {
  const questionsList = $('.questions-list');

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      this.perform('follow');
    },
    
    disconnected: function() {},
    
    received: function(data) {
      questionsList.append(data);
    }
  })
})
