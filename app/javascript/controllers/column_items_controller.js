import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs";
import { post } from '@rails/request.js'

export default class extends Controller {
  connect() {
    // Enable sorting for columns
    this.sortable = Sortable.create(this.element, {
      group: 'columns',
      animation: 150,
      handle: ".column-item-title", // Handle drag using the column title
      onEnd: this.reorder.bind(this)
    });
  }

  async reorder(event) {
    let columnOrder = Array.from(this.element.children).map((column, index) => {
      return { id: column.dataset.id, position: index + 1 };
    });
    const result = await post(`/boards/:board_id/column_items/:column_item_id/tasks/:id/reorder`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ order: columnOrder })
    });
  }
}
