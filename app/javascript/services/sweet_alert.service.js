import Swal from 'sweetalert2';

export default class SweetAlerts {
	static swalPopup(modalText, alertTitle = "Félicitations!", alertType = "success", fn = () => { }, ...args) {
		Swal.fire({
			title: alertTitle,
			text: modalText,
			icon: alertType,
			allowOutsideClick: false,
			allowEscapeKey: false,
		}).then((result) => {
			if (result.isConfirmed && alertType == "success") {
				fn(...args);
			}
		});
	}

	static async swalPopupQueue(modalText, alertTitle = "Félicitations!", alertType = "success", fn = () => { }, ...args) {
		await Swal.fire({
			title: alertTitle,
			text: modalText,
			icon: alertType,
			allowOutsideClick: false,
			allowEscapeKey: false,
		}).then((result) => {
			if (result.isConfirmed && alertType == "success") {
				fn(...args);
			}
		});
	}

	static async async_ask_for_smtg(txt, confirmation_msg, succ_title, succ_msg, succ = true, fn = () => { }, ...args) {
		const result = await Swal.fire({
			title: "Êtes-vous sûr?",
			text: txt,
			icon: "info",
			showCancelButton: true,
			confirmButtonColor: "#3085d6",
			cancelButtonColor: "#d33",
			confirmButtonText: confirmation_msg,
			allowOutsideClick: false,
			allowEscapeKey: false,
		});

		if (result.isConfirmed) {
			await fn(...args);
			if (succ) {
				await Swal.fire({
					title: succ_title,
					text: succ_msg,
					icon: "success"
				});
			}
		}
	}

	static ask_for_smtg(txt, confirmation_msg, succ_title, succ_msg, fn1 = () => { }, fn2 = () => { }) {
		Swal.fire({
			title: "Êtes-vous sûr?",
			text: txt,
			icon: "info",
			showCancelButton: true,
			confirmButtonColor: "#3085d6",
			cancelButtonColor: "#d33",
			confirmButtonText: confirmation_msg,
			allowOutsideClick: false,
			allowEscapeKey: false,
		}).then((result) => {
			if (result.isConfirmed) {
				fn1();
				Swal.fire({
					title: succ_title,
					text: succ_msg,
					icon: "success"
				});
			} else if (result.isDismissed) {
				fn2();
			}
		})
	}

	static ask_for_deletion(fn = () => { }, ...args) {
		Swal.fire({
			title: 'Confirmer la suppression',
			html: 'Êtes-vous sûr de vouloir supprimer cet élément ?<br>Cette action est irréversible et l\'élément ne pourra pas être récupéré.',
			icon: 'error',
			showCancelButton: true,
			confirmButtonText: 'Confirmer',
			cancelButtonText: 'Annuler',
			focusConfirm: false,
			customClass: {
				popup: 'ideo-swal-popup',
				title: 'ideo-swal-title',
				htmlContainer: 'ideo-swal-html',
				confirmButton: 'ideo-swal-confirm-button',
				cancelButton: 'ideo-swal-cancel-button',
				actions: 'ideo-swal-actionss'
			}
		}).then((result) => {
			if (result.isConfirmed) {
				fn(...args);
			}
		});
	}

	static ask_for_smtg_without_success(msg, fn1 = () => { }, fn2 = () => { }) {
		Swal.fire({
			title: "Êtes-vous sûr ?",
			text: msg,
			icon: "warning",
			showCancelButton: true,
			confirmButtonColor: "#3085d6",
			cancelButtonColor: "#d33",
			cancelButtonText: "Annuler",
			confirmButtonText: "Oui"
		}).then(async (result) => {
			if (result.isConfirmed) {
				fn1();
			} else if (result.isDismissed) {
				fn2();
			}
		});
	}

	static missingInputFields(msg = "") {
		Swal.fire({
			title: msg,
			icon: "warning",
			allowOutsideClick: false,
			allowEscapeKey: false,
		});
	}

}