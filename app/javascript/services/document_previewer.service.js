import ModalService from "./modal.service";

export default class DocumentPreviewer {
	constructor(btn_selector, doc_url, bg_modal_to_blur_id) {
		this.btn_selector = btn_selector;
		this.doc_url = doc_url;

		const modal = new ModalService(`${btn_selector.slice(1)}-modal`);
		modal.create('Aperçu du document', null, () => {
			const iframe = modal.modal.querySelector('iframe');
			iframe.style.minHeight = '80vh'
			if (iframe) {
				iframe.remove();
			}
			if (modal.modal) {
				modal.modal.remove();
			}
		});
		modal.style();

		const iframeContent = `
            <iframe src="${doc_url}" style="width: 100%; height: ${window.innerHeight * 0.7}px; border: none;"></iframe>
        `;
		modal.injectContent(iframeContent);

		const iframe = modal.modal.querySelector('iframe');
		iframe.addEventListener('load', function () {
			const iframeDocument = iframe.contentDocument || iframe.contentWindow.document;
			const images = iframeDocument.querySelectorAll('img');
			images.forEach(img => {
				img.style.width = '100%';
			});
		});

		if (bg_modal_to_blur_id) {
			const bg_modal = new ModalService(bg_modal_to_blur_id);
			bg_modal.blur();
			modal.modal.addEventListener("hidden.bs.modal", function () {
				bg_modal.unblur();
			});
		}

		modal.show();
	}
}
