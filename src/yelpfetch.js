var Yelp = require('node-yelp');

var client = Yelp.createClient({
    oauth: {
        "consumer_key": "QbaOtI4HhOIheBXDgL9Miw",
        "consumer_secret": "cyVWY4CZJ-o9hPw3XuAxRQbe3YE",
        "token": "UapxC4VIu4D7P6Wqpa8NK8OQLCoclwhb",
        "token_secret": "PRQtr_R-GmEffFPTkZ0qSGxR_ic"
    }
});

client.search({
    terms: "food",
    location: "101 N Main St. Ann Arbor, MI"
}).then(function(data) {
    console.log("***** SEARCH RESPONSE *****");
    console.log(data);
    console.log("***** END RESPONSE *****");
}).catch(function(err) {
    console.error("***** ERROR RESPONSE *****");
    console.error(err);
    console.error("***** END RESPONSE *****");
});

