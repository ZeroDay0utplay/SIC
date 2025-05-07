import { Controller } from "@hotwired/stimulus";
import HttpService from "../services/http.service";

export default class extends Controller {
  static values = { quoteId: String }

  connect() {
    this.quoteIdValue = this.extractQuoteIdFromUrl();
    this.clientId = document.getElementById("quote_client_id")?.value;

    document.addEventListener("turbo:submit-end", (event) => {
      if (event.detail.success) {
        this.fetchSelectData();
      } else {
        console.error("Turbo stream submission failed.");
      }
    });
  }

  extractQuoteIdFromUrl() {
    const urlParts = window.location.pathname.split('/');
    return urlParts[urlParts.indexOf("quotes") + 1];
  }

  async fetchSelectData() {
    const clients = await HttpService.get('/settings/clients.json');
    const prestations = await HttpService.get("/settings/prestations.json");
    const headings = await HttpService.get(`/finances/quotes/client-headings/${this.clientId}.json`);

    this.refreshSelect("quote_client_id", clients);
    this.refreshSelect("quote_prestation_id", prestations);
    this.refreshSelect("quote_heading_id", headings);
  }

  refreshSelect(select_id, values) {
    try {
      const select = document.getElementById(select_id);
      if (!select) {
        throw new Error(`Select element with id "${select_id}" not found.`);
      }

      const currentValue = select.value;

      select.innerHTML = '';

      const blankOption = new Option("Veuillez sélectionner", "", true);
      select.add(blankOption);

      values.forEach(value => {
        const option = new Option(value.name, value.id);
        select.add(option);
      });

      if (currentValue && values.some(c => c.id.toString() === currentValue)) {
        select.value = currentValue;
      }
    } catch (error) {
      console.error(`Error in refreshSelect: ${error.message}`);
    }
  }

}