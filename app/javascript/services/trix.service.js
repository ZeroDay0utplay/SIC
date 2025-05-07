import SweetAlerts from "./sweet_alert.service";

export default class TrxiEdit {

	static mimeToExtension = {
		'image/jpeg': 'jpg',
		'image/png': 'png',
		'image/gif': 'gif',
		'application/pdf': 'pdf',
		'text/plain': 'txt',
		'text/html': 'html',
		'application/json': 'json',
		'application/zip': 'zip',
	};

	static getFileExtension(blob) {
		const mimeType = blob.type;
		return this.mimeToExtension[mimeType] || '';
	}

	static imageAcceptation(document) {
		document.addEventListener("trix-file-accept", (event) => {
			const file = event.file;
			if (!this.isImage(file)) {
				event.preventDefault();
				SweetAlerts.swalPopup("", "Télécharger uniquement des images", "warning");
			}
		});
	}

	static isImage(file) {
		return file.type.match(/^image\/(gif|png|jpeg|webp)$/);
	}

	static removeProgressBar(document) {
		document.addEventListener("trix-attachment-add", (event) => {
			if (event.attachment.file) {
				event.attachment.setUploadProgress(100);
			}
		});
	}

	static async hashFile(file) {
		const arrayBuffer = await file.arrayBuffer();
		const hashBuffer = await crypto.subtle.digest('SHA-256', arrayBuffer);
		const hashArray = Array.from(new Uint8Array(hashBuffer));
		const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
		return hashHex;
	}

	static async getContentAndUploadAttachmentsFromId(id, uploadLink, topic_id, topic) {
		const superParentElement = document.getElementById(id)
		const elements = superParentElement.querySelector("trix-editor").children
		let trixCont = "";
		const len = elements.length;
		for (let i = 0; i < len; i++) {
			let el = elements[i]
			trixCont += await this.getContentAndUploadAttachments(el, uploadLink, topic_id, topic)
		}
		return trixCont;
	}

	static async getContentAndUploadAttachments(parent, uploadLink, topic_id, topic) {
		const imgElements = parent.querySelectorAll('img[src^="blob:"]');
		const imgLen = imgElements.length
		if (imgLen != 0) {
			Swal.fire({
				title: "Soyez patients !",
				text: "Nous sommes en train de télécharger des fichiers.",
				imageUrl: document.getElementById("data-upload-wait").src,
				imageWidth: 300,
				imageHeight: 300,
				imageStyle: "border-radius: 50%;",
				showConfirmButton: false,
			});
			const figures = parent.querySelectorAll("figure");
			for (let i = 0; i < imgLen; i++) {
				const imgElement = imgElements[i]
				const oldFig = figures[i];
				const figure = oldFig.cloneNode(true);
				const progress = figure.querySelector('progress');
				if (progress) {
					figure.removeChild(progress);
				}
				const blobUrl = imgElement.src;
				const response = await fetch(blobUrl);
				const blob = await response.blob();
				const fileExt = this.getFileExtension(blob);
				const hashedFile = await this.hashFile(blob);
				const filename = `${hashedFile}.${fileExt}`;
				const formUploadData = new FormData();
				formUploadData.append('file', blob, filename);
				formUploadData.append("topic_id", topic_id);
				formUploadData.append("topic", topic);
				await fetch(uploadLink, {
					method: 'POST',
					body: formUploadData
				})
				const dataTrixAttchment = JSON.parse(figure.getAttribute("data-trix-attachment"));
				dataTrixAttchment["contentType"] = "image";
				dataTrixAttchment["url"] = `/uploads/${topic}/${topic_id}/${filename}`;
				figure.removeAttribute("data-trix-attributes")
				figure.removeAttribute("data-trix-serialize")
				figure.setAttribute("data-trix-content-type", "image");
				delete dataTrixAttchment.filename;
				delete dataTrixAttchment.filesize;
				figure.setAttribute("data-trix-attachment", JSON.stringify(dataTrixAttchment));
				const oldImgElement = figure.querySelector("img");
				if (figure && oldImgElement) {
					figure.removeChild(oldImgElement);
				}
				const captionElement = figure.querySelector("figcaption")
				figure.removeChild(captionElement);

				parent.replaceChild(figure, oldFig);
			}
		}
		return parent.outerHTML;
	}

	static disapearTrixBtns() {
		const toolbarButtons = document.querySelectorAll("trix-toolbar button");
		toolbarButtons.forEach(button => {
			button.style.display = "none";
		});
	}

}