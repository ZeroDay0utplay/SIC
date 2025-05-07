import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="prestations"
export default class extends Controller {
  static targets = ['unity', 'typePrestation', 'prestationState']
  connect() {
    if(this.hasUnityTarget) {
      const config = {
        create: true,
        createOnBlur: true,
        render:{
          option_create: function( data, escape ){
            return '<div class="create">Ajouter <strong>' + escape(data.input) + '</strong>&hellip;</div>';
          },
          no_results: function( data, escape ){
            return '<div class="no-results">Aucun résultat trouvé</div>';
          },
        }
      }
      new TomSelect(this.unityTarget, config );
    }
  }

  showModal(event) {
    event.preventDefault()

    this.url = this.element.getAttribute('href')

    fetch(this.url, {
      headers: {
        Accept: 'text/vnd.turbo-stream.html'
      }
    })
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
  }

  checkTypePrestation(event) {
    if (event.target.value === 'rent') {
      this.prestationStateTarget.classList.remove('d-none')
    } else {
      this.prestationStateTarget.classList.add('d-none')
    }
  }
}
