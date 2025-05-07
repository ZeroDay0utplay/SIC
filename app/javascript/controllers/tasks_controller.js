import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs";

export default class extends Controller {
  connect() {
    this.sortable = Sortable.create(this.element, {
      group: 'tasks',
      animation: 150,
      handle: ".drag-icon",
      onEnd: this.reorder.bind(this)
    });
  }

  reorder(event) {
    let taskOrder = Array.from(this.element.children).map((task, index) => {
      return { id: task.dataset.id, position: index + 1, column_id: this.element.closest('.column-item').dataset.id };
    });

    fetch(`/boards/:board_id/column_items/:column_item_id/tasks/:id/reorder`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content },
      body: JSON.stringify({ order: taskOrder })
    });
  }
}
