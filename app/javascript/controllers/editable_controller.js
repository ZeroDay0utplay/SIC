import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["name", "newName", "form", "id", "message"];

  edit(event) {
    this.nameTarget.classList.add('d-none');
    this.formTarget.classList.remove('d-none')
  }

  update(event) {
    event.preventDefault();
    const skillId = this.idTarget.getAttribute("id");
    const newName = this.newNameTarget.value;

    fetch(`/settings/skills/${skillId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ skill: { name: newName } })
    })
      .then(response => {
        if (!response.ok) {
          return response.json().then(err => { throw new Error(err.errors.join(', ')); });
        }
        return response.json();
      })
      .then(data => {
        if(data.hasOwnProperty("errors")) {
          this.messageTarget.classList.remove('d-none')
        }else {
          this.messageTarget.classList.add('d-none')
          this.nameTarget.textContent = data.name;
          this.cancel();
        }
      })
      .catch(error => {
        console.error('Error updating skill:', error);
      });
  }

  cancel(event) {
    this.formTarget.classList.add('d-none');
    this.nameTarget.classList.remove('d-none');
  }
}