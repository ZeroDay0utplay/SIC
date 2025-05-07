export default class ModalService {

	constructor(modal_id) {
		this.modal_id = modal_id;
	}

	create(title, modal_content, onCloseCallback) {
		this.title = title;
		if (!modal_content) {
			modal_content = `
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="${this.modal_id}Label">${this.title}</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body">
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
						</div>
					</div>
			</div>
		`;
		}

		this.modal_content = modal_content;
		const modal = document.createElement('div');
		modal.className = 'modal fade';
		modal.id = this.modal_id;
		modal.tabIndex = -1;
		modal.setAttribute('aria-labelledby', `${this.modal_id}Label`);
		modal.setAttribute('aria-hidden', 'true');

		// content injection
		modal.innerHTML = this.modal_content;

		document.body.appendChild(modal);
		const bootstrapModal = new bootstrap.Modal(modal);
		this.modal = modal;
		this.bootstrapModal = bootstrapModal;
		modal.addEventListener("hidden.bs.modal", onCloseCallback);
	}

	style() {
		this.modal.style.minHeight = '1200px';
		this.modal.style.height = '1200px';

		const modalDialog = this.modal.querySelector(".modal-dialog");
		const modalContent = this.modal.querySelector(".modal-content");
		const modalBody = this.modal.querySelector(".modal-body");

		modalDialog.style.marginTop = '10px';
		modalDialog.style.minHeight = '90vh';
		modalDialog.style.minWidth = '70vw';
		modalDialog.style.borderRadius = '10px';

		modalContent.style.height = '100%';

		modalBody.style.overflowY = 'auto';
	}

	injectContent(content) {
		const modalBody = this.modal.querySelector('.modal-body');
		if (modalBody) {
			modalBody.innerHTML = content;
		} else {
			console.error('Modal body element not found.');
		}
	}

	show() {
		this.bootstrapModal.show();
	}

	hide() {
		this.bootstrapModal.hide();
	}

	blur() {
		try {
			document.querySelector(this.modal_id + ' .modal-backdrop').classList.add('modal-blur');

		} catch (error) { }
		try {
			document.querySelector(this.modal_id + ' .modal-content').classList.add('modal-content-blur');
		} catch (error) { }
	}

	unblur() {
		try {
			document.querySelector(this.modal_id + ' .modal-backdrop').classList.remove('modal-blur');

		} catch (error) { }
		try {
			document.querySelector(this.modal_id + ' .modal-content').classList.remove('modal-content-blur');
		} catch (error) { }
	}

}