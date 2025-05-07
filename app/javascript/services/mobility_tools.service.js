export default class MobilityToolsService {

	constructor(loaderBtnSelector) {
		; this.loadCSS("tools/btn_loader.css")
		const loaderBtn = document.querySelector(loaderBtnSelector)
		loaderBtn.insertAdjacentHTML("beforeend", '<div class="loader"></div>')
		const loader = document.querySelector("div.loader")
		this.loader = loader
		this.loaderBtn = loaderBtn
		this.paddingRight = parseFloat($(loaderBtnSelector).css('padding-right').slice(0, -2));
	}

	loadCSS(filename) {
		const link = document.createElement("link");
		link.rel = "stylesheet";
		link.type = "text/css";
		link.href = `/assets/${filename}`;
		document.head.appendChild(link);
	}

	delayer(ms) {
		return new Promise(resolve => setTimeout(resolve, ms));
	}

	async hideLoader(delay = 1000) {
		await this.delayer(delay);
		this.loader.style.display = "none";
		this.loaderBtn.disabled = false;
		this.loaderBtn.style.paddingRight = `${this.paddingRight}px`;
	}

	activateLoader() {
		this.loaderBtn.style.paddingRight = `${this.paddingRight + 10}px`;
		this.loader.style.display = "inline-block";
		this.loaderBtn.disabled = true;
	}

}