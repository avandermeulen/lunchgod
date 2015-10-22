

enterReplies = ['A new disciple comes to Me.', 'Join the flock and be fed.', 'Come unto Me']
leaveReplies = ['Thou art excommunicated.', 'Why hast thou forsaken Me?', 'I cast thee out!']

testList = ['Banditos', 'TK Wu', 'Broken Egg', 'Grizzly Peak', 'Blue Tractor']
testPrays = {}
testPrays[name] = 1 for name in testList
maxBless = 10
minBless = -10
maxPray = 5
minPray = -5

PRAYER_PROBABILITY = .05

range = (maxBless - minBless) + (maxPray - minPray)

consumer_key = "QbaOtI4HhOIheBXDgL9Miw"
consumer_secret = "cyVWY4CZJ-o9hPw3XuAxRQbe3YE"
token = "UapxC4VIu4D7P6Wqpa8NK8OQLCoclwhb"
token_secret = "PRQtr_R-GmEffFPTkZ0qSGxR_ic"

# Default search parameters
radius = 1000
sort = 0

trim_re = /^\s+|\s+$|[\.!\?]+$/g

# Create the API client
yelp = require("yelp").createClient consumer_key: consumer_key, consumer_secret: consumer_secret, token: token, token_secret: token_secret


lunchMe = (robot, res, location, query) ->
  # Clean up the query
  query = "food" if typeof query == "undefined"
  query = query.replace(trim_re, '')
  query = "food" if query == ""

  # Perform the search
  #msg.send("Looking for #{query} around #{location}...")
  yelp.search category_filter: "restaurants", term: query, radius_filter: radius, sort: sort, limit: 20, location: location, (error, data) ->
    if error != null
      return "..."

    if data.total == 0
      return "...."

    else
      return weightedRandom(robot, res, data)

weightedRandom = (robot, res, data) ->
    index = Math.floor(Math.random() * data.businesses.length)
    location = data.businesses[index].name
    url = data.businesses[index].url
    console.log(JSON.stringify(data))
    if location
      blessing = robot.brain.get(location.toLowerCase()) || 0
      if ((blessing + maxBless)/range >= Math.random())
        return "On this day, thou shalt go unto " + location + " and be fed. " + url
      else
        return weightedRandom(robot, res, data)
    else
      return "....."

petitionsMadeTodayByLocation = {}
petitionListIsDirty = false

makePetition = (robot, res) ->
  channel = res.message.room
  user = res.message.user.name

  shoreUpPetitionsList(robot)
  petitionListIsDirty = true

  petitions = petitionsMadeTodayByLocation[channel]
  if not petitions
    petitions = []
    petitionsMadeTodayByLocation[channel] = petitions

  petitions.push user
  syncPetitionsList(robot)
  return true

canPetition = (robot, res) ->
  channel = res.message.room
  user = res.message.user.name
  shoreUpPetitionsList(robot)
  petitions = petitionsMadeTodayByLocation[channel] or []
  return user not in petitions

clearDailyPetitionsBychannel = (robot) ->
  channel = res.message.room
  shoreUpPetitionsList(robot)
  petitionListIsDirty = true
  petitionsMadeTodayByLocation[channel] = []
  syncPetitionsList(robot)

shoreUpPetitionsList = (robot) ->
  console.log("attempting to load the god's master petition list");
  storedPetitionsList = robot.brain.get("global.petitionsMadeTodayByLocation")
  petitionsMadeTodayByLocation = storedPetitionsList if storedPetitionsList and not petitionListIsDirty

syncPetitionsList = (robot) ->
  console.log("persiting petition list!!!")
  robot.brain.set("global.petitionsMadeTodayByLocation", petitionsMadeTodayByLocation)
  robot.brain.save()
  petitionListIsDirty = false

module.exports = (robot) ->
  robot.respond /i would like to join this congregation/i, (res) ->
    channel = res.message.roo
    user = res.message.user.name
    makePetition(robot, res)
    res.send("added " + user + "@" + channel + " to daily petitions list");

  robot.respond /have i been faithful\?/i, (res) ->
    channel = res.message.room
    user = res.message.user.name
    msg = "can"
    msg = "cannot" if not canPetition(robot, res)
    res.send(user + "@" + channel + " " + msg + " petition again today")

  robot.respond /absolve my congregation of their sins!/i, (res) ->
    channel = res.message.room
    clearDailyPetitionsBychannel(robot, res)
    res.send("Daily petitions list for @" + channel + " has been cleared")

  robot.respond /show me your faithful/, (res) ->
    shoreUpPetitionsList(robot)
    res.send("```" + JSON.stringify(petitionsMadeTodayByLocation, null, "\t") + "```");

  robot.respond /i pray for (.*) food/i, (res) ->
    foodType = res.match[1]
    if (Math.random() < PRAYER_PROBABILITY)
      robot.brain.set("prayers.food_type", foodType)
      res.reply "THOUST PRAYER HATH BEEN HEARD"
    else
      res.reply "THOUST PRAYERS HATH GONE UNANSWERED"

  robot.respond /yelp me(.*)/i, (res) ->
    query = res.match[1]
    listenToGodImg res
    #lunchMe res, query, false
  robot.respond /init/, (res) ->
    waitASec
    robot.brain.set('prayrecord',testPrays)
    robot.brain.save()
    record = robot.brain.get('prayrecord')['Banditos']
    res.reply "Banditos #{record}."
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
    res.send "Blessed art #{target}."

  robot.respond /pray (.*)/, (res) ->
    waitASec
    target = res.match[1]
    prays = robot.brain.get(target.toLowerCase()) || 0
    if prays < maxPray
      robot.brain.set(target.toLowerCase(), prays + 1)
      robot.brain.save()
    res.send "Prayed art #{target}."

  robot.respond /curse (.*)/, (res) ->
    waitASec
    target = res.match[1]
    blessings = robot.brain.get(target.toLowerCase()) || 0
    if blessings > minBless
      robot.brain.set(target.toLowerCase(), blessings - 1)
      robot.brain.save()
    res.send "Cursed art #{target}."

  robot.respond /how blessed art (.*)\?/, (res) ->
    waitASec
    target = res.match[1]
    blessings = robot.brain.get(target.toLowerCase()) || 0
    if blessings == 0
      res.send "#{target} art profane."
    else if blessings == maxBless
      res.send "#{target} art holy."
    else if blessings == minBless
      res.send "#{target} art excommunicated."
    else if blessings > 0
      res.send "#{target} art blessed."
    else if blessings < 0
      res.send "#{target} art cursed."

  robot.respond /we dwell (in|at) (.*)/, (res) ->
    waitASec
    location = res.match[2]
    channel = "#" + res.message.room
    robot.brain.set(channel.toLowerCase(), location)
    robot.brain.save()
    res.send "Henceforth My light shalt shine upon #{location}"

  robot.respond /show us the way[!]?/, (res) ->
    waitASec
    res.send "I can not hear thou."

  robot.respond /SHOW US THE WAY!/, (res) ->
    waitASec
    channel = "#" + res.message.room
    location = robot.brain.get(channel.toLowerCase())
    if location
      res.send lunchMe(robot, res, location, "food")
    else
      res.send "Where dost thou dwell?"

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

waitASec = () ->
  sleep(Math.floor(Math.random() * (1500 - 500)) + 500)

listenUrls = [
  "http://barbwire.wpengine.netdna-cdn.com/wp-content/uploads/2015/01/hearinggod.jpg"
  "http://www.stewardshipoflife.org/wordpress/wp-content/uploads/2011/01/3133347219_4c16658dd51-370x280.jpg"
  "http://newcsj.squarespace.com/storage/listen.png?__SQUARESPACE_CACHEVERSION=1427384743876"
  "http://sevenstorylearning.com/wp-content/uploads/2011/05/Listen-by-BRosen.jpg"
]
listenToGodImg = (msg) ->
  return msg.random listenUrls
