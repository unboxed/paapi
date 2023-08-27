import { Controller } from '@hotwired/stimulus';
import consumer from '../channels/consumer';

export default class extends Controller {
  static targets = ['messages'];

  connect() {
    this.channel = consumer.subscriptions.create('MessageChannel', {
      connected: this._cableConnected.bind(this),
      disconnected: this._cableDisconnected.bind(this),
      received: this._cableReceived.bind(this),
    });
  }

  clearInput() {
    this.inputTarget.value = '';
  }

  _cableConnected() {
    // Called when the subscription is ready for use on the server
  }

  _cableDisconnected() {
    // Called when the subscription has been terminated by the server
  }

  _cableReceived(data) {
    if(this.messagesTarget.querySelectorAll(`[data-message-id="${data.id}"]`).length > 0) {
      console.log('Already added');
      return;
    }

    if(this.lastInfoElements == null) {
      this.lastInfoElements = [];
    }

    const li = document.createElement('li');
    li.setAttribute('data-message-id', data.id);
    li.setAttribute('data-created-at', data.created_at);
    li.setAttribute('data-message-type', data.type);
    li.textContent = data.body;
    if(data.type == 'info') {
      if(this.lastInfoElements.length > 0) {
        let lastInfoElement = this.lastInfoElements[this.lastInfoElements.length - 1];
        const lastCreatedAt = lastInfoElement.getAttribute('data-created-at');
        const lastMessageType = lastInfoElement.getAttribute('data-message-type');
        if(lastCreatedAt != null && lastMessageType == 'info') {
          if(data.created_at > lastCreatedAt) {
            if(this.messagesTarget.childElementCount > 0) {
              this.messagesTarget.removeChild(lastInfoElement);
            }
          } else return;
        }
      }
    }
    if(data.type == 'info') {
      this.lastInfoElements.push(li);
    }
    this.messagesTarget.appendChild(li);
  }
}