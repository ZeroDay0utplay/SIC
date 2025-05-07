import BaseFinanceController from "./base_finance_controller";
import TomSelect from "tom-select";

export default class extends BaseFinanceController {
  static targets = [
    "quantity",
    "unitPrice",
    "unity",
    "days",
    "reduction",
    "reductionUnit",
    "pricePretax",
    "inputPricePretax",
    "hasDescription",
    "hasReduction"
  ];

  connect() {
    this.updateInputNames();
    this.changeOrder();
    this.updatePrice();
    this.updateSummaryPrice();
    this.showTotalPricePerLine();
    this.initTomSelect();
  }

  updatePrice(event) {
    const quantity = parseFloat(this.quantityTarget.value) || 0;
    const unitPrice = parseFloat(this.unitPriceTarget.value) || 0;
    const days = parseFloat(this.daysTarget.value) || 1;

    let pricePretax = quantity * unitPrice * days;

    if (this.hasReductionTarget.checked) {
      const reduction = parseFloat(this.reductionTarget.value) || 0;
      pricePretax = this.reductionUnitTarget.value === "currency"
        ? pricePretax - reduction
        : pricePretax - (pricePretax * reduction) / 100;
    }

    pricePretax = parseFloat(pricePretax.toFixed(2));

    this.pricePretaxTarget.innerHTML = `${pricePretax}€`;
    this.inputPricePretaxTarget.value = pricePretax;
    this.updateSummaryPrice();
  }

  showReduction(event) {
    this.reductionTarget.disabled = !event.target.checked;
    this.reductionUnitTarget.disabled = !event.target.checked;
  }

  updateInputNames() {
    document.querySelectorAll(".cover-quote-item").forEach((item, index) => {
      item.setAttribute("id", `quote-item-${index}`);

      item.querySelectorAll("input, select, textarea").forEach((input) => {
        input.name = input.name.replace(/__INDEX__/, index);
        input.id = input.id.replace(/__INDEX__/, index);
      });

      const orderElement = item.querySelector(".order-count");
      if (orderElement) {
        orderElement.textContent = index + 1;
      }
    });
  }

  initTomSelect() {
    if (!this.hasUnityTarget || this.unityTarget.tomselect) return;

    new TomSelect(this.unityTarget, {
      create: true,
      createOnBlur: true,
      render: {
        option_create: (data, escape) =>
          `<div class="create">Ajouter <strong>${escape(data.input)}</strong>&hellip;</div>`,
        no_results: () => '<div class="no-results">Aucun résultat trouvé</div>'
      }
    });
  }
}