import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// Connects to data-controller="commercial-catalogue"
export default class extends Controller {
  static targets = ["getCatalogue", "prestationItem", "prestationType", "prestationTypeId"]
  connect() {
    if (this.hasPrestationTypeTarget) {
      this.prestationTypeIdTarget.value = 'service'
      this.prestationTypeTargets.forEach((item) => item.addEventListener('click', this.setPrestationType.bind(this)));
    }
  }

  setPrestationType(e) {
    this.prestationTypeIdTarget.value = e.target.getAttribute('aria-controls');
  }

  getCatalogue(e) {
    fetch('/finances/prestations', {
      method: 'GET',
      headers: {
        Accept: 'text/vnd.turbo-stream.html',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
  }

  addPrestation(event) {
    event.preventDefault()
    fetch(`/prestations/new/`, {
      headers: {
        Accept: 'text/vnd.turbo-stream.html'
      }
    })
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
  }

  setPrestation(event) {
    event.preventDefault()
    const prestationId = event.target.dataset.value
    fetch(`/finances/prestations/${prestationId}`, {
      method: 'GET',
      headers: {
        Accept: 'text/vnd.turbo-stream.html',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
  }

  search(event) {
    const query = event.target.value.toLowerCase();
    let hasMatch = false;
    this.prestationItemTargets.forEach((item) => {
      const itemName = item.innerText.toLowerCase();
      if (itemName.includes(query)) {
        item.classList.add("d-block");
        item.classList.remove("d-none");
        hasMatch = true;
      } else {
        item.classList.add("d-none");
        item.classList.remove("d-block");
      }
    });
    if (!query) {
      this.hideAllItems();
    }
  }

  hideAllItems() {
    this.prestationItemTargets.forEach((item) => {
      item.classList.add("d-none");
      item.classList.remove("d-block");
    });
  }
}
