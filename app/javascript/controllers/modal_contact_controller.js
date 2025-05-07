import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="modal-contact"
export default class extends Controller {
  static targets = ["job", "company", "client"]
  connect() {
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
    if(this.hasJobTarget && this.hasClientTarget && this.hasCompanyTarget) {
      new TomSelect(this.jobTarget, config);
      new TomSelect(this.clientTarget, { });
      new TomSelect(this.companyTarget, config);
    }
  }
}