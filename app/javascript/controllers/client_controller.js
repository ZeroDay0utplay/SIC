import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="client"
export default class extends Controller {
  static targets = ["company", "address", "city", "postal_code", "country", "suggestions", "errorFields"];

  connect() {
    this.pappersData = []
  }

  getCompany(event) {
    const companyName = event.target.value.trim();
    if (companyName.length < 3) {
      this.clearSuggestions();
      return;
    }

    const url = `https://suggestions.pappers.fr/v2?q=${encodeURIComponent(companyName)}`;

    fetch(url)
      .then(response => response.json())
      .then(data => {
        if (data.resultats_nom_entreprise && data.resultats_nom_entreprise.length > 0) {
          this.pappersData = data
          this.showSuggestions(data.resultats_nom_entreprise);
        } else {
          this.clearSuggestions();
          this.markFieldsAsError();
        }
      })
      .catch(error => {
        this.clearSuggestions();
        this.markFieldsAsError();
      });
  }

  showSuggestions(results) {
    this.suggestionsTarget.innerHTML = '';

    results.forEach((result) => {
      const suggestionElement = document.createElement('div');
      suggestionElement.className = 'suggestion-item';
      suggestionElement.setAttribute('id', 0);
      suggestionElement.innerHTML = `${result.nom_entreprise} <br><i>${result.domaine_activite}</i>`;
      suggestionElement.addEventListener('click', () => this.fillFields(result));

      this.suggestionsTarget.appendChild(suggestionElement);
    });

    this.suggestionsTarget.classList.remove('d-none');
  }

  fillFields(data) {
    document.getElementById("client_name").value = data.nom_entreprise
    this.addressTarget.value = data.siege.adresse_ligne_1 || '';
    this.cityTarget.value = data.siege.ville || '';
    this.postal_codeTarget.value = data.siege.code_postal || '';
    this.countryTarget.value = data.siege.pays || 'France';

    this.clearErrorState();
    this.clearSuggestions();
  }

  clearSuggestions() {
    this.suggestionsTarget.innerHTML = '';
    this.suggestionsTarget.classList.add('d-none');
  }

  markFieldsAsError() {
    this.errorFieldsTargets.forEach(field => {
      if (!field.value.trim()) {
        field.classList.add('error');
      } else {
        field.classList.remove('error');
      }
    });
  }

  clearErrorState() {
    this.errorFieldsTargets.forEach(field => {
      field.classList.remove('error');
    });
  }
}
