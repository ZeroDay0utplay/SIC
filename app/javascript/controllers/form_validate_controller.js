import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="form-validate"
/*
Developer Guide:
================
1. Attach this controller to your form using `data-controller="form-validate"`.
2. Use `data-action` to trigger validation for inputs (blur, keyup, or change).
3. Add a span or div with `data-form-validate-target="errorMessage"` next to each input.
4. For radio buttons, use `data-form-validate-target="radioGroup"` on each input in the group.
5. The submit button should have `data-form-validate-target="submit"` and will be disabled until all inputs are valid.
6. Handle submit click for radio group errors with `data-action="click->form-validate#handleSubmit"`.
*/

export default class extends Controller {
  static targets = ["input", "radioGroup", "submit", "errorMessage", "radioGroupError"];

  connect() {
    if(this.hasSubmitTarget){
      this.updateSubmitState();
    }
  }

  validate(event) {
    const input = event.target;
    const errorMessage = input.nextElementSibling;

    if (input.type === "radio") {
      this.clearRadioGroupError();
    } else {
      const isValid = this.checkValidity(input);
      if (!isValid) {
        errorMessage.textContent = this.getErrorMessage(input);
        input.classList.add("is-invalid");
      } else {
        errorMessage.textContent = "";
        input.classList.remove("is-invalid");
      }
    }

    this.updateSubmitState();
  }

  updateSubmitState() {
    const allInputsValid = this.inputTargets.every((input) => this.checkValidity(input));
    let radioValid = false;
    if(this.hasRadioGroupTarget){
      radioValid = this.radioGroupTargets.some((radio) => radio.checked);
    }else {
      radioValid = true
    }

    this.submitTarget.disabled = !(allInputsValid && radioValid);

    if(this.hasRadioGroupTarget){
      if (!radioValid) {
        this.showRadioGroupError();
      } else {
        this.clearRadioGroupError();
      }
    }
  }

  handleSubmit(event) {
    if (this.submitTarget.disabled) {
      event.preventDefault();

      if(this.hasRadioGroupTarget){
        const radioValid = this.radioGroupTargets.some((radio) => radio.checked);
        if (!radioValid) {
          this.showRadioGroupError();
        }
      }
    }
  }

  showRadioGroupError() {
    this.radioGroupErrorTarget.textContent = "Vous devez sélectionner une option.";
  }

  clearRadioGroupError() {
    this.radioGroupErrorTarget.textContent = "";
  }

  checkValidity(input) {
    const pattern = input.dataset.pattern;
    const minLength = input.dataset.minLength;
    const value = input.value.trim();

    if (input.type === "radio") return true;
    if (!value) return false;
    if (minLength && value.length < parseInt(minLength, 10)) return false;
    if (pattern && !new RegExp(pattern).test(value)) return false;

    return true;
  }

  getErrorMessage(input) {
    if (!input.value.trim()) {
      return "Ce champ est requis.";
    }
    if (input.dataset.minLength && input.value.length < parseInt(input.dataset.minLength, 10)) {
      return `Ce champ doit comporter au moins ${input.dataset.minLength} caractères.`;
    }
    if (input.dataset.pattern) {
      return input.dataset.errorMessage || "Format non valide.";
    }
    return "";
  }
}
