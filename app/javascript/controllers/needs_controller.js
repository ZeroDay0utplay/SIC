import { Controller } from "@hotwired/stimulus";
import { Modal } from "bootstrap"
import TomSelect from "tom-select";
import { French } from "flatpickr/dist/l10n/fr.js"
import SweetAlerts from "../services/sweet_alert.service"

// Connects to data-controller="needs"
export default class extends Controller {
  static targets = ["clientList", "multipleDateInput", "assignAgent", "prestationsList", "dateStartInput", "dateEndInput",
                    "taskModal", "interventionDays", "addTasksButton"];

  connect() {
    if (this.hasClientListTarget && this.hasPrestationsListTarget) {
      new TomSelect(this.clientListTarget, { plugins: ['dropdown_input'] });
      new TomSelect(this.prestationsListTarget, { plugins: ['dropdown_input'] });
    }

    if (this.hasMultipleDateInputTarget) {
      this.initDatePickers();
    }

    if (this.hasDateStartInputTarget && this.hasDateEndInputTarget) {
      this.initRegularDatePickers();
    }

    if(this.hasTaskModalTarget) {
      this.modal = new Modal(this.taskModalTarget)
    }

  }

  initializeTomSelect(item) {
    const config = {
      plugins: ["clear_button", "remove_button"],
    };

    if (!item.tomselect) {
      this.tomSelectInstance = new TomSelect(item, config);
    } else {
      this.tomSelectInstance = item.tomselect;
    }
  }

  initDatePickers() {
    this.dateMultiplePicker = flatpickr(this.multipleDateInputTarget, {
      mode: "multiple",
      dateFormat: "d-m-Y",
      locale: French
    });
  }

  initRegularDatePickers() {
    this.dateStartInputPicker = flatpickr(this.dateStartInputTarget, {
      dateFormat: "d-m-Y",
      locale: French
    });
    this.dateEndInputPicker = flatpickr(this.dateEndInputTarget, {
      dateFormat: "d-m-Y",
      locale: French
    });
  }

  changeClient(event) {
    const id = event.target.value
    const model = event.target.dataset.model

    if (id) {
      fetch(`/needs/get_interventions/${id}/${model}`, {
        headers: {
          "Accept": "text/vnd.turbo-stream.html"
        }
      })
        .then(response => response.text())
        .then(html => {
          Turbo.renderStreamMessage(html)
        })
        .catch(error => {
          console.error("Error fetching:", error);
        });
    }
  }

  assignAgent() {
    fetch(`/needs/get_agents`, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
      .then(response => response.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
      .catch(error => {
        console.error("Error fetching:", error);
      });
  }

  openMaterialsModal() {
    fetch(`/needs/get_materials`, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
      .then(response => response.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
      .catch(error => {
        console.error("Error fetching:", error);
      });
  }

  checkDispatch(event) {
    if (event.target.checked) {
      this.assignAgentTarget.removeAttribute('disabled')
    } else {
      this.assignAgentTarget.setAttribute('disabled', true)
    }
  }

  openTaskModal(event) {
    if (this.hasDateStartInputTarget && this.hasDateEndInputTarget) {
      if(this.dateStartInputTarget?.value === "" || this.dateEndInputTarget?.value === "") {
        SweetAlerts.missingInputFields("Avant de continuer, veuillez renseigner la date de début et la date de fin.")
        return
      }
    }

    event.preventDefault()
    this.modal.show()
  }

  canAddTasks(event) {
    event.preventDefault()
    if(event.target.checked) {
      this.interventionDaysTarget.classList.add("d-none")
      this.addTasksButtonTarget.classList.remove("d-none")
    } else {
      this.interventionDaysTarget.classList.remove("d-none")
      this.addTasksButtonTarget.classList.add("d-none")
    }
  }
}