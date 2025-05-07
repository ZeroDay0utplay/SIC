import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="user-skills"
export default class extends Controller {
  connect() {
    this.initializeTomSelect();
  }

  initializeTomSelect() {
    var config = {
      create: true,
      plugins: ['clear_button', 'remove_button'],
    }

    if (!this.element.tomselect) {
      this.tomSelectInstance = new TomSelect(this.element, config);
    } else {
      this.tomSelectInstance = this.element.tomselect;
    }
  }

}
