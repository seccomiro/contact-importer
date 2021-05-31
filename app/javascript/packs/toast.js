import { Toast } from "bootstrap";

export default (text, action) => {
  const toasts = document.querySelector(".app-toasts");
  toasts.innerHTML += `
    <div class="toast align-items-center" role="alert" aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body">
          ${text}
          <div class="mt-2 pt-2 border-top">
            <a href="${action}" class="btn btn-primary btn-sm">Check</a>
            <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="toast">Close</button>
          </div>
        </div>
      </div>
    </div>
  `;

  document.querySelectorAll(".toast").forEach(function (toastEl) {
    const toast = new Toast(toastEl, { autohide: false });
    toast.show();
  });
};
