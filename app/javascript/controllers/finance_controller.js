import BaseFinanceController from "./base_finance_controller";

export default class extends BaseFinanceController {
  static targets = ["templateName"]
  connect() {
    if (this.hasItemsContainerTarget) {
      this.updateSummaryPrice();
    }
  }

  showInputsFirstStep(event) {
    const container = document.getElementById(event.target.dataset.binding);
    container?.classList.toggle("d-none");
  }

  removeItem(event) {
    event.preventDefault();
    const item = event.target.closest(".cover-quote-item");
    const itemIdInput = item?.querySelector("input[name*='[id]']");

    if (itemIdInput?.value) {
      const destroyInput = document.createElement("input");
      destroyInput.type = "hidden";
      destroyInput.name = itemIdInput.name.replace("[id]", "[_destroy]");
      destroyInput.value = "1";
      item.appendChild(destroyInput);
      item.style.display = "none";
    } else {
      item?.remove();
    }

    this.changeOrder();
  }

  changeClient(event) {
    this.fetchAndRender(`/finances/quotes/client-headings/${event.target.value}`);
  }

  changeAdmin(event) {
    this.fetchAndRender(`/finances/quotes/admin-details/${event.target.value}`);
  }

  showModal(event) {
    event.preventDefault();
    this.fetchAndRender(event.target.href);
  }

  showGlobalReduction(event) {
    const reductionInput = document.getElementById("quote_reduction");
    const reductionUnitInput = document.getElementById("quote_reduction_unit");

    if (reductionInput) reductionInput.disabled = !event.target.checked;
    if (reductionUnitInput) reductionUnitInput.disabled = !event.target.checked;

    this.updateSummaryPrice();
  }

  fetchAndRender(url) {
    if (!url) return;

    fetch(url, {
      headers: { "Accept": "text/vnd.turbo-stream.html" }
    })
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
      .catch(error => console.error("Error fetching:", error));
  }

  useAsTemplate(event) {
    event.preventDefault();
    if(event.target.checked) {
      this.templateNameTarget.classList.remove("d-none");
    }else {
      this.templateNameTarget.classList.add("d-none");
    }
  }
}