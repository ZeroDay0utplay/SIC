import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "intervention", "interventionList", "interventionItem", "address", "suggestions"]

  connect() {
    this.baseUrl = "https://nominatim.openstreetmap.org/search"
    this.timeout = null
    this.previousQuery = ""
  }

  onInput() {
    const query = this.inputTarget.value.trim()
    if (query.length >= 3 && query !== this.previousQuery) {
      this.previousQuery = query
      clearTimeout(this.timeout)
      this.timeout = setTimeout(() => {
        this.fetchSuggestions(query)
      }, 300)
    } else if (query.length < 3) {
      this.clearSuggestions()
    }
  }

  onFocus(event) {
    this.interventionListTarget.style.display = "block"
  }

  onBlur(event) {
    setTimeout(()=>{
      this.interventionListTarget.style.display = "none"
    }, 300)
  }

  fetchSuggestions(query) {
    const url = `${this.baseUrl}?q=${encodeURIComponent(query)}&format=json&addressdetails=1&limit=5&countrycodes=FR`

    fetch(url)
      .then(response => response.json())
      .then(data => this.updateSuggestions(data))
      .catch(error => {
        console.error("Error fetching suggestions: ", error)
        this.clearSuggestions()
      })
  }

  updateSuggestions(results) {
    const suggestionsDiv = this.suggestionsTarget
    suggestionsDiv.innerHTML = ""

    if (results.length > 0) {
      results.forEach((result) => {
        const formattedAddress = this.formatAddress(result)
        const div = document.createElement("div")
        div.classList.add("suggestion")

        div.setAttribute('data-address-search-target', 'interventionItem');
        div.setAttribute('data-action', 'click->address-search#setAddress');
        div.setAttribute('data-id', "-1");

        div.innerHTML = formattedAddress
        setTimeout(()=> {
          div.onclick = () => this.selectSuggestion(result)
        }, 100)
        suggestionsDiv.appendChild(div)
      })
      suggestionsDiv.style.display = "block"
    } else {
      this.clearSuggestions()
    }
  }

  formatAddress(result) {
    const address = result.address
    const street = address.road || ''
    const houseNumber = address.house_number || ''
    const city = address.city || address.town || address.village || ''
    const postalCode = address.postcode || ''
    const country = address.country || ''

    return `${houseNumber} ${street}, ${postalCode} ${city}, ${country}`
  }

  setAddress(event) {
    this.inputTarget.value = event.target.innerText
    this.addressTarget.value = event.target.innerText
    this.interventionTarget.value = event.target.dataset.id
  }

  selectSuggestion(result) {
    this.inputTarget.value = this.formatAddress(result)
    this.clearSuggestions()

    const divElement = document.createElement("div")
    divElement.classList.add('intervention-item');
    divElement.setAttribute('data-address-search-target', 'interventionItem');
    divElement.setAttribute('data-action', 'click->address-search#setAddress');
    divElement.setAttribute('data-id', `-1`);
    divElement.innerText = this.formatAddress(result);
    this.interventionListTarget.append(divElement)
    this.interventionListTarget.value = -1
  }

  clearSuggestions() {
    this.suggestionsTarget.innerHTML = ""
    this.suggestionsTarget.style.display = "none"
  }
}
