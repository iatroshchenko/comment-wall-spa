const baseURL = '/api';
const axiosInstance = require('axios').create({
  baseURL
});
axios = require('axios').create();
axios.defaults.withCredentials = true;

// exports
module.exports = {
  apiClient: axiosInstance,
  client: axios
};
