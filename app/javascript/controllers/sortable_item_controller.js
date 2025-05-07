import Sortable from "@stimulus-components/sortable"

export default class extends Sortable {
  connect() {
    super.connect()

    this.options
    this.sortable
    this.defaultOptions
  }

  onUpdate(event) {
    this.changeOrder(event)
  }

  get defaultOptions() {
    return {
      animation: 500,
    }
  }

  changeOrder() {
    let visibleItems = Array.from(document.querySelectorAll("#items-container .cover-quote-item")).filter(item => item.style.display !== "none");

    visibleItems.forEach((element, index) => {
      let orderElement = element.querySelector(".order-count");
      if (orderElement) {
        element.querySelector("input[id*='order']").value = index
        orderElement.textContent = index + 1;
      }
    });
  }
}