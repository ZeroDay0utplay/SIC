export default class CalendarService {
	constructor(calendarId, events_api, clickCallback) {
		const calendarEl = document.getElementById(calendarId);
		this.calendar = new FullCalendar.Calendar(calendarEl, {
			initialDate: new Date(),
			initialView: "dayGridMonth",
			headerToolbar: {
				left: "prev,next",
				center: "title",
				right: "today",
			},
			selectable: true,
			dayMaxEvents: 3,
			events: events_api,
			eventClick: function (info) {
				info.jsEvent.preventDefault();
				clickCallback(info)
			},
		})
		this.calendar.render();
	}

	changeEventSource(newUrl) {
		this.calendar.setOption('events', newUrl);
		this.calendar.refetchEvents();
	}

}