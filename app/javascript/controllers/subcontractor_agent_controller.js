import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="subcontractor-agent"
export default class extends Controller {
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
}
