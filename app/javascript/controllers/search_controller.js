import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  static targets = ["input", "itemsPerPage", "skills", "status", "pageInput", "typePrestation", "url",
                    "state", "date", "multipleDateInput", "startDate", "endDate", "skeletonLoader", "skeletonTable", "months", "selectedMonths"]

  connect() {

  }

  search(event) {
    this.performSearch()
  }

  changeItemsPerPage(event) {
    this.performSearch()
  }

  getByPrestationType(event) {
    this.typePrestation = event.target.value
    this.performSearch()
  }

  getByState(event) {
    this.state = event.target.value
    this.performSearch()
  }

  filterDate(event) {
    if (!this.datePickerInitialized) {
      this.datePicker = flatpickr(this.dateTarget, {
        mode: "multiple",
        dateFormat: "Y-m-d",
        onChange: (selectedDates, dateStr, instance) => {
          this.creation_dates = dateStr.split(",")
          this.performSearch();
        }
      });
      this.datePickerInitialized = true;
    }
  }

  filterByMonth(event) {
    let values = []

    this.monthsTargets.forEach(input => {
      if (input.checked) values.push(input.value)
    });

    values = [...new Set(values)];
    this.selectedMonthsTarget.value = values

    this.performSearch();
  }

  getBetweenDates(event) {
    if (this.hasStartDateTarget && this.hasEndDateTarget) {
      const startDate = this.startDateTarget.value
      const endDate = this.endDateTarget.value

      if(startDate != '' && endDate != '') {
        this.performSearch()
      }
    }
  }

  injectPropToUrl(url, prop_name, object) {
    if (object != '' && object != undefined) {
      url.searchParams.set(prop_name, encodeURIComponent(object));
    }
  }

  performSearch() {
    let url

    if (this.hasSkeletonLoaderTarget) this.skeletonLoaderTarget.style.display = "block"
    if (this.hasSkeletonTableTarget) this.skeletonTableTarget.style.display = "none"

    try {
      if (this.hasUrlTarget) {
        if (this.urlTarget.getAttribute('action') != '') {
          url = new URL(`${window.location.origin}${this.urlTarget.getAttribute('action')}`)
        }
      } else {
        url = new URL(window.location.pathname, window.location.origin)
      }
    } catch (error) {
      console.error("Invalid URL:", error)
      if (this.hasSkeletonTarget) this.skeletonTarget.style.display = "none"
      return
    }

    const searchQuery = this.hasInputTarget ? this.inputTarget.value : ''
    const itemsPerPage = this.hasItemsPerPageTarget ? this.itemsPerPageTarget.value : 10
    const skills = this.hasSkillsTarget ? this.skillsTarget.value : ''
    const status = this.hasStatusTarget ? this.statusTarget.value : ''
    const page = this.hasPageInputTarget && parseInt(this.pageInputTarget.value) > 0 ? this.pageInputTarget.value : 1
    const multipleDateInput = this.hasMultipleDateInputTarget ? this.multipleDateInputTarget.value : ''
    const selectedMonths = this.hasSelectedMonthsTarget ? this.selectedMonthsTarget.value : ''

    if (multipleDateInput != '') {
      url.searchParams.set(this.multipleDateInputTarget.name, multipleDateInput)
    }

    if (this.hasStartDateTarget && this.hasEndDateTarget) {
      url.searchParams.set("start_date", this.startDateTarget.value)
      url.searchParams.set("end_date", this.endDateTarget.value)
    }


    if (searchQuery != '')
      this.injectPropToUrl(url, this.inputTarget.name, searchQuery)

    this.injectPropToUrl(url, "items", itemsPerPage)
    this.injectPropToUrl(url, "page", page)
    this.injectPropToUrl(url, "skills", skills)
    this.injectPropToUrl(url, "type_prestation", this.typePrestation)
    this.injectPropToUrl(url, "state", this.state)
    this.injectPropToUrl(url, "creation_dates", this.creation_dates)
    this.injectPropToUrl(url, "status", status)
    this.injectPropToUrl(url, "selectedMonths", selectedMonths)

    fetch(url.toString(), {
      headers: {
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
      .then(response => response.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
      .catch(error => {
        console.error("Error fetching search results:", error)
      })
      .finally(() => {
        if (this.hasSkeletonLoaderTarget) this.skeletonLoaderTarget.style.display = "none"
        if (this.hasSkeletonTableTarget) this.skeletonTableTarget.style.display = "block"
      });
  }
}
