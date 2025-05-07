import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-validation"
export default class extends Controller {
  static targets = ["submit"]
  connect() {
    this.requiredList = ""
  }

  submitForm(event) {
    // let isValid = this.validateForm();

    // if (!isValid) {
    //   event.preventDefault();
    //   return false
    // } else {
    //   this.element.submit()
    // }
  }

  validateForm() {
    let isValid = true;
    let requiredFieldSelectors = "input:required, select:required, textarea:required";
    let requiredFields = this.element.querySelectorAll(requiredFieldSelectors);

    requiredFields.forEach((field) => {

      if (field.tagName == "SELECT") {

        if (field.value == 0) {
          if (field.hasOwnProperty('tomselect')) {
            field.tomselect.focus()
            isValid = false
          }
          return false
        }

      } else if (!field.disabled && !field.value.trim()) {

        field.focus();
        isValid = false;
        return false;

      } else if (field.type == 'checkbox') {

        if (!field.checked) {
          field.focus();
          isValid = false
          return false
        }

      } else {
        isValid = true
      }
    });

    return isValid;
  }
}
