enterReplies = ['A new disciple comes to Me.', 'Join the flock and be fed.', 'Come unto Me']
leaveReplies = ['Thou art excommunicated.', 'Why hast thou forsaken Me?', 'I cast thee out!']

testList = ['Banditos', 'TK Wu', 'Broken Egg', 'Grizzly Peak', 'Blue Tractor']
testPrays = {}
testPrays[name] = 1 for name in testList
#robot.brain.set(prayrecord,testPrays)
#robot.brain.save()
maxBless = 10
minBless = -10
maxPray = 5
minPray = -5

range = (maxBless - minBless) + (maxPray - minPray)

consumer_key = "QbaOtI4HhOIheBXDgL9Miw"
consumer_secret = "cyVWY4CZJ-o9hPw3XuAxRQbe3YE"
token = "UapxC4VIu4D7P6Wqpa8NK8OQLCoclwhb"
token_secret = "PRQtr_R-GmEffFPTkZ0qSGxR_ic"

# Default search parameters
start_address = "Ann Arbor"
radius = 1000
sort = 0
default_suggestion = "Broken Egg"

trim_re = /^\s+|\s+$|[\.!\?]+$/g

# Create the API client
yelp = require("yelp").createClient consumer_key: consumer_key, consumer_secret: consumer_secret, token: token, token_secret: token_secret


lunchMe = (msg, query, random = true) ->
  # Clean up the query
  query = "food" if typeof query == "undefined"
  query = query.replace(trim_re, '')
  query = "food" if query == ""

  # Extract a location from the query
  split = query.split(/\snear\s/i)
  query = split[0]
  location = split[1]
  location = start_address if (typeof location == "undefined" || location == "")

  # Perform the search
  #msg.send("Looking for #{query} around #{location}...")
  yelp.search category_filter: "restaurants", term: query, radius_filter: radius, sort: sort, limit: 20, location: location, (error, data) ->
    if error != null
      return msg.send "There was an error searching for #{query}. Maybe try #{default_suggestion}?"

    if data.total == 0
      return msg.send "I couldn't find any #{query} for you. Maybe try #{default_suggestion}?"

    if random
      business = data.businesses[Math.floor(Math.random() * data.businesses.length)]
    else
      business = data.businesses[0]
    msg.send("How about " + business.name + "? " + business.url)


module.exports = (robot) ->
  robot.respond /yelp me(.*)/i, (res) ->
    query = res.match[1]
    lunchMe res, query, false

  robot.respond /dev.ping/, (res) ->
    waitASec
    res.send omniscience.ping()

  robot.respond /dev.list (.*)/, (res) ->
    waitASec
    location = res.match[1]
    res.send("```" + JSON.stringify(omniscience.list(location), null, "\t") + "```")

  robot.respond /bless (.*)/, (res) ->
    waitASec
    target = res.match[1]
    blessings = robot.brain.get(target.toLowerCase()) || 0
    if blessings < maxBless
      robot.brain.set(target.toLowerCase(), blessings + 1)
      robot.brain.save()
    res.reply "Blessed art #{target}."

  robot.respond /pray (.*)/, (res) ->
    waitASec
    target = res.match[1]
    prays = robot.brain.get(target.toLowerCase()) || 0
    if prays < maxPray
      robot.brain.set(target.toLowerCase(), prays + 1)
      robot.brain.save()
    res.reply "Prayed art #{target}."

  robot.respond /curse (.*)/, (res) ->
    waitASec
    target = res.match[1]
    blessings = robot.brain.get(target.toLowerCase()) || 0
    if blessings > minBless
      robot.brain.set(target.toLowerCase(), blessings - 1)
      robot.brain.save()
    res.reply "Cursed art #{target}."

  robot.respond /how blessed art (.*)\?/, (res) ->
    waitASec
    target = res.match[1]
    blessings = robot.brain.get(target.toLowerCase()) || 0
    if blessings == 0
      res.reply "#{target} art profane."
    else if blessings == maxBless
      res.reply "#{target} art holy."
    else if blessings == minBless
      res.reply "#{target} art excommunicated."
    else if blessings > 0
      res.reply "#{target} art blessed."
    else if blessings < 0
      res.reply "#{target} art cursed."

  robot.respond /we dwell (in|at) (.*)/, (res) ->
    waitASec
    location = res.match[2]
    channel = res.message.user.channel
    res.reply res.toString()
    #res.reply channel + ": " + location

  robot.respond /show us the way[!]?/, (res) ->
    waitASec
    res.reply "I can not hear thou."

  robot.respond /SHOW US THE WAY!/, (res) ->
    waitASec
    res.send weightedRandom(testList)

  robot.hear /.+ lunch[ ]?god/i, (res) ->
    waitASec
    name = res.message.user.name
    res.reply "Thou shalt not take My Name in vain!"

  robot.enter (res) ->
    waitASec
    res.reply res.random enterReplies

  robot.leave (res) ->
    waitASec
    res.reply res.random leaveReplies

  weightedRandom = (list) ->
    index = Math.floor(Math.random() * list.length)
    location = list[index]
    blessing = robot.brain.get(location.toLowerCase()) || 0
    if ((blessing + maxBless)/range >= Math.random())
      return location
    else
      return weightedRandom(list)

waitASec = () ->
  sleep(Math.floor(Math.random() * (1500 - 500)) + 500)
