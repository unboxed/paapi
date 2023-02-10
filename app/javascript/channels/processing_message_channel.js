import consumer from "./consumer"

let channelName = "MessageChannel"; 
consumer.subscriptions.create({channel: channelName}, {
  connected() {
    console.log(`Connected to ${channelName}`);
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log(`Disconnected from ${channelName}`); 
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log('Received');
    // Called when there's incoming data on the websocket for this channel
    console.log(data)
  }
});
