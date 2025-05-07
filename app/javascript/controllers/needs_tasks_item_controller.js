// app/javascript/controllers/needs_tasks_item_controller.js
import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import { French } from "flatpickr/dist/l10n/fr.js"

export default class extends Controller {
  static targets = ["dateRange", "frequency", "frequencyDays", "taskForm"]

  connect() {
    if (this.element.dataset.planningType == "Regular") {
      flatpickr.localize(French)

      this.programmaticChange = false
      this.selectedWeeks = []
      this.initFlatpickr()

      this.frequencyTargets.forEach(el =>
        el.addEventListener("change", () => {
          this.dateRangeTarget.value = ""
          this.selectedWeeks = []
          this.fp.destroy()
          this.initFlatpickr()
        })
      )

      this.frequencyDaysTargets.forEach(cb =>
        cb.addEventListener("change", () => {
          const currentDates = this.fp.selectedDates
          this.fp.destroy()
          this.initFlatpickr(currentDates)
        })
      )
    }
  }

  initFlatpickr(preselectedDates = []) {
    const minDate = new Date(this.formatDate(document.querySelector("#regular_start_on").value))
    const maxDate = new Date(this.formatDate(document.querySelector("#regular_finish_on").value))

    minDate.setHours(0, 0, 0, 0)
    maxDate.setHours(0, 0, 0, 0)

    let disable = []

    const allowedDays = this.frequencyDaysTargets
      .filter(cb => cb.checked)
      .map(cb => Number(cb.value))

    disable = [
      function (date) {
        return !allowedDays.includes(date.getDay())
      }
    ]

    this.fp = flatpickr(this.dateRangeTarget, {
      mode: "multiple",
      dateFormat: "Y-m-d",
      minDate,
      maxDate,
      disable,
      defaultDate: preselectedDates,
      onChange: this.handleDateChange.bind(this),
    })
  }



  handleDateChange(selectedDates, _dateStr, instance) {
    if (this.programmaticChange || !selectedDates.length) return

    const picked = instance.latestSelectedDateObj
    const mode = this.frequencyTargets.find(r => r.checked)?.value

    if (mode === "weekly") {
      this.applyWeeklyMode(picked)
    } else if (mode === "half-monthly") {
      this.applyHalfMonthlyMode(picked)
    } else if (mode === "monthly") {
      this.applyMonthlyMode(picked)
    }
  }

  applyMonthlyMode(date) {
    const selectedDay = date.getDay()
    const allowedDays = this.frequencyDaysTargets
      .filter(cb => cb.checked)
      .map(cb => Number(cb.value))

    if (!allowedDays.includes(selectedDay)) {
      this.programmaticChange = true
      this.fp.setDate(this.fp.selectedDates.filter(d => d.getTime() !== date.getTime()), false)
      this.programmaticChange = false
      return
    }

    const filtered = this.fp.selectedDates.filter(d => d.getDay() !== selectedDay)
    const newDates = [...filtered, date].sort((a, b) => a - b)

    this.programmaticChange = true
    this.fp.setDate(newDates, false)
    this.programmaticChange = false
  }

  applyHalfMonthlyMode(date) {
    const allowedDays = this.frequencyDaysTargets
      .filter(cb => cb.checked)
      .map(cb => Number(cb.value))

    const selectedDay = date.getDay()

    if (!allowedDays.includes(selectedDay)) {
      this.programmaticChange = true
      this.fp.setDate(this.fp.selectedDates.filter(d => d.getTime() !== date.getTime()), false)
      this.programmaticChange = false
      return
    }

    const sameWeekdayDates = this.fp.selectedDates.filter(d => d.getDay() === selectedDay)

    let newDates

    if (sameWeekdayDates.length > 3) {
      newDates = this.fp.selectedDates.filter(d => d.getDay() !== selectedDay)
      newDates.push(date)
    } else {
      newDates = [...this.fp.selectedDates, date]
    }

    newDates = [...new Set(newDates.map(d => d.getTime()))].map(t => new Date(t)).sort((a, b) => a - b)

    this.programmaticChange = true
    this.fp.setDate(newDates, false)
    this.programmaticChange = false

  }


  applyWeeklyMode(date) {
    const allowed = this.frequencyDaysTargets
      .filter(cb => cb.checked)
      .map(cb => Number(cb.value))

    const selectedDay = date.getDay()

    if (!allowed.includes(selectedDay)) {
      this.programmaticChange = true
      this.fp.setDate(this.fp.selectedDates.filter(d => d.getTime() !== date.getTime()), false)
      this.programmaticChange = false
      return
    }

    const uniqueDates = [...new Set(this.fp.selectedDates.map(d => d.getTime()))]
      .map(t => new Date(t))
      .sort((a, b) => a - b)

  }

  formatDate(date) {
    let [day, month, year] = date.split('-');
    return new Date(`${year}-${month}-${day}`);
  }

  getMonday(d) {
    const dt = new Date(d)
    const day = dt.getDay() || 7
    dt.setDate(dt.getDate() - day + 1)
    return dt
  }

  getSunday(monday) {
    const dt = new Date(monday)
    dt.setDate(dt.getDate() + 6)
    return dt
  }

  getDatesBetween(start, end) {
    const arr = []
    let cur = new Date(start)
    while (cur <= end) {
      arr.push(new Date(cur))
      cur.setDate(cur.getDate() + 1)
    }
    return arr
  }

  iso(d) {
    return d instanceof Date ? d.toISOString().slice(0, 10) : ""
  }

  sameDay(a, b) {
    return a && b &&
      a.getFullYear() === b.getFullYear() &&
      a.getMonth() === b.getMonth() &&
      a.getDate() === b.getDate()
  }
}
