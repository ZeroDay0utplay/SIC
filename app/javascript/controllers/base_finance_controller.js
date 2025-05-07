import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["itemsContainer"];

  // Common methods used by both controllers [FinanceController and FinanceItemController]
  showTotalPricePerLine() {
    const checkbox = document.querySelector("input[type='checkbox'][id$='_display_total_with_tax']");
    const displayClass = checkbox.checked ? "remove" : "add";

    document.querySelectorAll(".prices-pretax").forEach(element => {
      element.classList[displayClass]("d-none");
    });
  }

  changeOrder() {
    const items = this.getVisibleItems();

    items.forEach((element, index) => {
      const orderElement = element.querySelector(".order-count");
      if (orderElement) {
        element.querySelector("input[id*='order']").value = index;
        orderElement.textContent = index + 1;
      }
    });
  }

  updateSummaryPrice() {
    const {
      quoteReduction,
      quoteReductionUnit,
      hasReduction
    } = this.getReductionValues();

    const sum = this.calculateSum();
    const tax = parseFloat((sum * 0.2).toFixed(2));
    const reduction = this.calculateReduction(sum, quoteReduction, quoteReductionUnit, hasReduction);
    const total = parseFloat((sum + tax - reduction).toFixed(2));

    this.updatePriceElements(sum, tax, reduction, total);
  }

  // Helper methods
  getVisibleItems() {
    const items = this.hasItemsContainerTarget
      ? this.itemsContainerTarget.querySelectorAll(".cover-quote-item")
      : document.querySelectorAll(".cover-quote-item");

    return Array.from(items).filter(item => item.style.display !== "none");
  }

  getReductionValues() {
    return {
      quoteReduction: document.getElementById("quote_reduction")?.value || "0",
      quoteReductionUnit: document.getElementById("quote_reduction_unit")?.value || "currency",
      hasReduction: document.getElementById("quote_commercial_detail_attributes_display_global_discount")?.checked || false
    };
  }

  calculateSum() {
    return Array.from(document.querySelectorAll(".input-price-pretax"))
      .reduce((acc, element) => acc + (parseFloat(element.value) || 0), 0);
  }

  calculateReduction(sum, quoteReduction, quoteReductionUnit, hasReduction) {
    if (!hasReduction) return 0;

    return quoteReductionUnit === "currency"
      ? parseFloat(quoteReduction) || 0
      : parseFloat((sum * quoteReduction) / 100);
  }

  updatePriceElements(sum, tax, reduction, total) {
    const elements = {
      leftTotalTax: document.getElementById("left-total-tax"),
      leftPricePretax: document.getElementById("left-prcie-pretax"),
      rightPricePretax: document.getElementById("right-price-pretax"),
      rightTotalTax: document.getElementById("right-total-tax"),
      rightTotalPrice: document.getElementById("right-total-prcie"),
      rightGlobalReduction: document.getElementById("right-global-reduction")
    };

    if (elements.leftTotalTax) elements.leftTotalTax.innerHTML = `${tax}€`;
    if (elements.leftPricePretax) elements.leftPricePretax.innerHTML = `${sum.toFixed(2)}€`;
    if (elements.rightGlobalReduction) elements.rightGlobalReduction.innerHTML = `${reduction.toFixed(2)}€`;
    if (elements.rightTotalTax) elements.rightTotalTax.innerHTML = `${tax}€`;
    if (elements.rightPricePretax) elements.rightPricePretax.innerHTML = `${sum.toFixed(2)}€`;
    if (elements.rightTotalPrice) elements.rightTotalPrice.innerHTML = `${total}€`;
  }
}