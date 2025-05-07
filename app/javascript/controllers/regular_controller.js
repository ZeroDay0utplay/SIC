import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="regular"
export default class extends Controller {
  connect() {
  }

  toggleAgent(event) {
    event.preventDefault()
  }
}
