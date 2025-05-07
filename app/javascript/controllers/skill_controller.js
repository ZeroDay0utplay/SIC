import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="skill"
export default class extends Controller {
  static targets = ["input", "submitButton"];

  connect() {
    this.checkName = this.checkName.bind(this);
  }

  checkName() {
    const skillName = this.inputTarget.value.trim();
    if (skillName === "") {
      this.submitButtonTarget.disabled = true;
      return;
    }

    fetch(`/settings/skills/check_name?name=${encodeURIComponent(skillName)}`)
      .then(response => response.json())
      .then(data => {
        if (data.exists) {
          this.submitButtonTarget.disabled = true;
        } else {
          this.submitButtonTarget.disabled = false;
        }
      })
      .catch(error => {
        console.error("Error checking skill name:", error);
        this.submitButtonTarget.disabled = true;
      });
  }
}
