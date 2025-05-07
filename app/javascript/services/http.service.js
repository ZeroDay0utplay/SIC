export default class HttpService {
  static #csrfToken = document.querySelector('meta[name="csrf-token"]').content;

  static async get(url, json = true) {
    try {
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      if (json === true) {
        return await response.json();
      }
      return response;
    } catch (error) {
      console.error('Error in GET request:', error);
    }
  }

  static async post(url, data, json = true) {
    try {
      var req_obj = { method: 'POST' };
      if (json === true) {
        req_obj.headers = {
          'Content-Type': 'application/json',
          'X-CSRF-Token': HttpService.#csrfToken
        };
        data = JSON.stringify(data);
      }
      req_obj.body = data;
      const response = await fetch(url, req_obj);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      if (json === true) {
        return await response.json();
      }
      return response;
    } catch (error) {
      console.error('Error in POST request:', error);
    }
  }

  static async put(url, data, json = true) {
    try {
      var headers = {};
      if (json === true) {
        headers = {
          'Content-Type': 'application/json',
          'X-CSRF-Token': HttpService.#csrfToken
        };
        data = JSON.stringify(data);
      }
      const response = await fetch(url, {
        method: 'PUT',
        headers: headers,
        body: data,
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      if (json === true) {
        return await response.json();
      }
      return response;
    } catch (error) {
      console.error('Error in PUT request:', error);
    }
  }

  static async patch(url, data, json = true) {
    try {
      var headers = {};
      if (json === true) {
        headers = {
          'Content-Type': 'application/json',
          'X-CSRF-Token': HttpService.#csrfToken
        };
        data = JSON.stringify(data);
      }
      const response = await fetch(url, {
        method: 'PATCH',
        headers: headers,
        body: data,
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      if (json === true) {
        return await response.json();
      }
      return response;
    } catch (error) {
      console.error('Error in PATCH request:', error);
    }
  }

  static async delete(url, json = true) {
    try {
      var headers = {};
      if (json === true) {
        headers = {
          'Content-Type': 'application/json',
          'X-CSRF-Token': HttpService.#csrfToken
        };
      }
      const response = await fetch(url, {
        method: 'DELETE',
        headers: headers,
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response;
    } catch (error) {
      console.error('Error in DELETE request:', error);
    }
  }

  static async getTurbo(url) {
    try {
      const response = await fetch(url, {
        headers: {
          Accept: 'text/vnd.turbo-stream.html',
        },
      });
      const html = await response.text();
      Turbo.renderStreamMessage(html);
    } catch (error) {
      console.error('Error in GET Turbo request:', error);
    }
  }

  static async postTurbo(url, data) {
    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': HttpService.#csrfToken,
          Accept: 'text/vnd.turbo-stream.html',
        },
        body: JSON.stringify(data),
      });
      const responseClone = response.clone();
      const html = await response.text();
      Turbo.renderStreamMessage(html);
      return responseClone;
    } catch (error) {
      console.error('Error in POST Turbo request:', error);
    }
  }

  static async deleteTurbo(url) {
    try {
      const response = await fetch(url, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': HttpService.#csrfToken,
          Accept: 'text/vnd.turbo-stream.html',
        },
      });
      const responseClone = response.clone();
      const html = await response.text();
      Turbo.renderStreamMessage(html);
      return responseClone;
    } catch (error) {
      console.error('Error in DELETE Turbo request:', error);
    }
  }
}
