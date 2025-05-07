import { Controller } from "@hotwired/stimulus";
import { French } from "flatpickr/dist/l10n/fr.js";

// Connects to data-controller="punctuals"
export default class extends Controller {
  static targets = ["multipleDateInput"];
  connect() {
    if (this.hasMultipleDateInputTarget) {
      this.initDatePickers();
    }
  }

  initDatePickers() {
    this.dateMultiplePicker = flatpickr(this.multipleDateInputTarget, {
      mode: "multiple",
      dateFormat: "d-m-Y",
      locale: French
    });
  }
}
