// app/javascript/avatar_preview.js
document.addEventListener("turbo:load", function() {
  const avatarInput = document.getElementById("edit-avatar");
  const preview = document.getElementById("avatar-preview");
  if (avatarInput && preview) {
    avatarInput.addEventListener("change", (event) => {
      const input = event.target;
      if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = (e) => {
          preview.src = e.target.result;
        };
        reader.readAsDataURL(input.files[0]);
      }
    });
  }
});
//# sourceMappingURL=/assets/avatar_preview.js.map
