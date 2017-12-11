App.messages = App.cable.subscriptions.create('MessagesChannel', {
  received: function(data) {
    window.location.replace(data.link);
  }
});
