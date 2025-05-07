import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import { French } from "flatpickr/dist/l10n/fr.js"

// Connects to data-controller="regular-agent"
export default class extends Controller {
  static targets = ["agentId", "date", "scheduleInput"]

  connect() {
    this.availableDates = document.getElementById("available-dates").value
    this.selectedDates = JSON.parse(this.element.dataset.selectedDatesParam || "[]")

    if (!this.agentIdTarget.checked) {
      this.dateTarget.disabled = true
    } else {
      this.updateSelectedDates(this.selectedDates)
    }

    if (!this.dateTarget.disabled) {
      this.initializeFlatpickr()
    }
  }

  initializeFlatpickr() {
    if (this.flatpickr) return

    const availableDates = this.parseAvailableDates()
    this.flatpickr = flatpickr(this.dateTarget, {
      mode: "multiple",
      dateFormat: "d-m-Y",
      locale: French,
      enable: availableDates,
      defaultDate: this.datesFormatted(this.selectedDates, true),
      onChange: this.updateSelectedDates.bind(this)
    })
  }

  datesFormatted(dates, reverse) {
    return dates.map(date => {
      const parsed_date = new Date(date)
      const year = parsed_date.getFullYear()
      const month = String(parsed_date.getMonth() + 1).padStart(2, '0')
      const day = String(parsed_date.getDate()).padStart(2, '0')
      if(reverse) {
      return `${day}-${month}-${year}`
      } else {
        return `${year}-${month}-${day}`
      }
    })
  }

  destroyFlatpickr() {
    if (this.flatpickr) {
      this.flatpickr.destroy()
      this.flatpickr = null
      this.updateSelectedDates([])
    }
  }

  parseAvailableDates() {
    try {
      const rawDates = JSON.parse(this.availableDates)
      return rawDates.map(d => {
        const [year, month, day] = d.split("-")
        return new Date(`${year}-${month}-${day}`)
      })
    } catch (e) {
      console.warn("Invalid available dates:", e)
      return []
    }
  }

  updateSelectedDates(selectedDates) {
    const formattedDates = this.datesFormatted(selectedDates, false)
    const agentId = this.element.dataset.agentId
    const assignment = {
      agent_id: agentId,
      dates: formattedDates
    }

    this.scheduleInputTarget.value = JSON.stringify(assignment)
  }

  toggleAgent(event) {
    const isChecked = event.target.checked
    this.dateTarget.disabled = !isChecked
    this.dateTarget.value = ""

    if (isChecked) {
      this.updateSelectedDates(this.selectedDates)
      this.initializeFlatpickr()
    } else {
      this.destroyFlatpickr()
    }
  }
}