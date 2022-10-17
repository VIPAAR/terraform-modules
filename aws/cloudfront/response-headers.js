'use strict';
const cfg = require('./config.json');
exports.handler = (event, context, callback) => {
    //Get contents of response
    const response = event.Records[0].cf.response;
    const headers = response.headers;

    //Set new headers
    Object.entries(cfg).forEach(([key,value]) => {
        headers[key] = [
            {key: key, value: value}
        ];
    });

    //Return modified response
    callback(null, response);
};
