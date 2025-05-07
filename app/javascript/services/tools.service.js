export default class Tools {
	static timeout(ms) {
		return new Promise(resolve => setTimeout(resolve, ms));
	}

	static async sleep(sleep_time) {
		await this.timeout(sleep_time);
	}
}
