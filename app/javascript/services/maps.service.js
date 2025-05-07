
export default class GoogleMapsService {
	constructor(map_selector) {
		this.map = new google.maps.Map(document.getElementById(map_selector), {
			center: { lat: 46.4596, lng: 2.747729 },
			zoom: 6,
			mapTypeId: "roadmap",
			streetViewControl: false,
			mapTypeControl: false
		});
	}

	static getAddressFromMaps(input_id) {
		const input = document.getElementById(input_id);
		new google.maps.places.Autocomplete(input, { types: ['geocode'] });
	}

	createMarker(position, iconUrl, iconX, iconY, labelText, anchorX = null, anchorY = null) {
		const markerOptions = {
			position: position,
			map: this.map,
		};

		const markerIconObject = {
			url: "",
			scaledSize: new google.maps.Size(iconX, iconY),
		};
		if (anchorX !== null && anchorY !== null) {
			markerIconObject.anchor = new google.maps.Point(anchorX, anchorY);
		}
		if (iconUrl) {
			markerIconObject.url = iconUrl
		}
		if (labelText) {
			markerOptions.title = labelText;
			markerOptions.label = labelText;
		}
		markerOptions.icon = markerIconObject;
		const marker = new google.maps.Marker(markerOptions);
		return marker;
	}
}