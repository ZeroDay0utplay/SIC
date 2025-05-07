import { Controller } from "@hotwired/stimulus"

// app/javascript/controllers/needs-tasks-controller.js
export default class extends Controller {
  static targets = ["taskList", "taskForm", "taskTemplate"]

  connect() {
    this.taskCounter = 0
  }

  addTask(event) {
    event.preventDefault();

    const uniqueId = this.taskCounter++;
    const template = this.taskTemplateTarget.innerHTML.replace(/TASK_ID/g, uniqueId);

    const tempDiv = document.createElement("div");
    tempDiv.innerHTML = template;

    tempDiv.querySelectorAll("[name]").forEach(field => {
      field.name = field.name.replace("[tasks]", `[tasks][${uniqueId}]`);
    });

    this.taskListTarget.prepend(tempDiv.firstElementChild);
  }

  removeTask(event) {
    event.preventDefault()
    const task = event.target.closest('.cover-task')
    task.remove()
  }

}