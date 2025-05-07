import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="needs-agents"
export default class extends Controller {
  static targets = ["agentID"]
  connect() {
    this.agentsListTarget = document.querySelector("input[data-name='agentsList']");
    setTimeout(() => {
      this.syncCheckedState()
    }, 200)
  }

  syncCheckedState() {
    const agentsList = JSON.parse(this.agentsListTarget.value || "[]");
    const checkboxes = this.element.querySelectorAll("input[data-action*='toggleAgentID']");

    checkboxes.forEach((checkbox) => {
      checkbox.checked = agentsList.includes(checkbox.value);
    });
  }

  toggleAgentID(event) {
    const agentID = event.target.value;
    let agentsList = JSON.parse(this.agentsListTarget.value || "[]");

    if (event.target.checked) {
      if (!agentsList.includes(agentID)) agentsList.push(agentID);
    } else {
      agentsList = agentsList.filter(id => id !== agentID);
    }

    this.agentsListTarget.value = JSON.stringify(agentsList);
  }

  clearAgentsList() {
    document.querySelector("input[data-name='agentsList']").value = ""
  }

  disconnect() {

  }
}
