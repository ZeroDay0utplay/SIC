import { Controller } from "@hotwired/stimulus"
import HttpService from "../services/http.service"
import SweetAlerts from "../services/sweet_alert.service"

export default class extends Controller {
  static targets = ['itemToBeRemoved']
  connect() {

  }

  showModal(event) {
    event.preventDefault()

    this.url = this.element.getAttribute('href')

    fetch(this.url, {
      headers: {
        Accept: 'text/vnd.turbo-stream.html'
      }
    })
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
  }

  confirmDestroy(event) {
    event.preventDefault();

    this.url = event.target.dataset.url || event.target.getAttribute('href');

    SweetAlerts.ask_for_deletion(async () => {
      HttpService.deleteTurbo(this.url);
    })
  }
}
