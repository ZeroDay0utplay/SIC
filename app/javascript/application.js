import "@hotwired/turbo-rails"
import "turbolinks"
import "./controllers"
import "./avatar_preview"
import * as bootstrap from "bootstrap"
import Trix from "trix"
import flatpickr from "flatpickr"

import { Application } from "@hotwired/stimulus";

const application = Application.start();

import $ from "jquery";

import Rails from "@rails/ujs";
Rails.start();

import Turbolinks from "turbolinks"
Turbolinks.start()

window.jQuery = $;
window.$ = $;
window.Trix = Trix

window.bootstrap = bootstrap;
window.flatpickr = flatpickr;

function checkSideBar() {
  const isSidebarMinimized = localStorage.getItem("sidebar") === "true";
  if (isSidebarMinimized) {
    $(".main-container").addClass("min-sidebar");
  } else {
    $(".main-container").removeClass("min-sidebar");
  }
}

function toggleSidebar() {
  const isMinimized = !$(".main-container").hasClass("min-sidebar");
  localStorage.setItem("sidebar", isMinimized.toString());
  $(".main-container").toggleClass("min-sidebar");
}

document.addEventListener("turbolinks:load", function () {
  const sidebareId = document.getElementById("toggle-sidebar")
  checkSideBar()

  if(sidebareId != null) {
    sidebareId.addEventListener("click", toggleSidebar);
  }
});

document.addEventListener("turbo:load", function () {
  const sidebareId = document.getElementById("toggle-sidebar")
  checkSideBar()

  if(sidebareId != null) {
    sidebareId.addEventListener("click", toggleSidebar);
  }

  $("#light-dark").on("click", () => {
    $("body").toggleClass("dark-mode")
  })

  /*----- BEGIN Preview company logo -----*/
  const avatarInput = document.getElementById("edit-avatar");
  const containerLogo = document.getElementById("cover-preview-picture");
  const preview = document.createElement("img");

  if (avatarInput && containerLogo) {
    avatarInput.addEventListener("change", (event) => {
      const input = event.target;

      if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = (e) => {
          preview.src = e.target.result;
          containerLogo.append(preview)
        };
        reader.readAsDataURL(input.files[0]);
      }
    });
  }
  /*----- END Preview company logo -----*/

});
