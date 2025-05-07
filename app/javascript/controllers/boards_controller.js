import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['boardsList']
  connect() {

  }

  loadBoard(event) {
    event.preventDefault()
    const id = event.target.value

    if (id != '') {
      fetch(`/boards/${id}`, {
        headers: {
          Accept: 'text/vnd.turbo-stream.html'
        }
      })
        .then(response => response.text())
        .then(html => Turbo.renderStreamMessage(html))
    }
  }

  showModal(event) {
    event.preventDefault()

    const url = event.target.getAttribute('href')

    if (url != null) {
      fetch(url, {
        headers: {
          Accept: 'text/vnd.turbo-stream.html'
        }
      })
        .then(response => response.text())
        .then(html => Turbo.renderStreamMessage(html))
    }
  }
}