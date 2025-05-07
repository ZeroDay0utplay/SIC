import { Controller } from "@hotwired/stimulus"
import HttpService from "../services/http.service"

export default class extends Controller {
  connect() {    
  }

  showModal(event) {
    event.preventDefault()

    this.url = this.element.getAttribute('href')

    HttpService.getTurbo(this.url);
  }
}
