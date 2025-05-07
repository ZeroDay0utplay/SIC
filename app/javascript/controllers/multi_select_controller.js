import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "toggleAll", "option","toggleAllLabel"];

  updateSelection() {
    const checkboxes = this.element.querySelectorAll("input[type='checkbox']:not([data-multi-select-target='toggleAll'])");
    const selectedCount = [...checkboxes].filter(checkbox => checkbox.checked).length;

    this.inputTarget.value = `${selectedCount} sélectionné(s)`;

    this.toggleAllTarget.checked = selectedCount === checkboxes.length;
    selectedCount === checkboxes.length ? this.toggleAllLabelTarget.innerText = "Tout désélectionner" : this.toggleAllLabelTarget.innerText = "Tout sélectionner";
  }

  toggleAll(event) {
    const checkboxes = this.element.querySelectorAll("input[type='checkbox']:not([data-multi-select-target='toggleAll'])");
    const shouldCheck = event.target.checked;

    checkboxes.forEach(checkbox => {
      checkbox.checked = shouldCheck;
    });

    if(shouldCheck){
      this.toggleAllLabelTarget.innerText = "Tout désélectionner";
    }
    else{
      this.toggleAllLabelTarget.innerText = "Tout sélectionner";
    }

    this.inputTarget.value = shouldCheck ? `${checkboxes.length} sélectionné(s)` : "0 sélectionné(s)";
  }

  search(event) {
    const query = event.target.value.toLowerCase();

    this.optionTargets.forEach(option => {
      const text = option.innerText.toLowerCase();
      option.style.display = text.includes(query) ? "block" : "none";
    });
  }
}
