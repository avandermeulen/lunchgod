

enterReplies = ['A new disciple comes to Me.', 'Join the flock and be fed.', 'Come unto Me']
leaveReplies = ['Thou art excommunicated.', 'Why hast thou forsaken Me?', 'I cast thee out!']
listenUrls = [
  "http://barbwire.wpengine.netdna-cdn.com/wp-content/uploads/2015/01/hearinggod.jpg",
  "http://www.stewardshipoflife.org/wordpress/wp-content/uploads/2011/01/3133347219_4c16658dd51-370x280.jpg",
  "http://newcsj.squarespace.com/storage/listen.png?__SQUARESPACE_CACHEVERSION=1427384743876",
  "http://sevenstorylearning.com/wp-content/uploads/2011/05/Listen-by-BRosen.jpg"
]
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
      return res.send "..."

    if data.total == 0
      return res.send "...."

    else
      return res.send weightedRandom(robot, res, data)

weightedRandom = (robot, res, data) ->
    index = Math.floor(Math.random() * data.businesses.length)
    location = data.businesses[index]
    if location
      blessing = robot.brain.get(location.name.toLowerCase()) || 0
      channel = res.message.room
      channelKey = "#{channel}.history"
      history = robot.brain.get(channelKey) || []
      if (location.is_closed == false && location.name not in history && (blessing + maxBless)/range >= Math.random())
        history.push(location.name)
        history.shift()
        robot.brain.set(channelKey, history)
        robot.brain.save()
        return "On this day, thou shalt go unto " + location.name + " and be fed. " + location.url
      else
        return weightedRandom(robot, res, data)
    else
      return "....."

petitionsMadeTodayByLocation = {}
petitionListIsDirty = false

makePetition = (robot, res) ->
  channel = res.message.room
  user = res.message.user.name
  
  if not canPetition(robot, res)
    return false

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

clearDailyPetitionsByChannel = (robot) ->
  channel = res.message.room
  shoreUpPetitionsList(robot)
  petitionListIsDirty = true
  petitionsMadeTodayByLocation[channel] = []
  syncPetitionsList(robot)
  
shoreUpPetitionsList = (robot) ->
  storedPetitionsList = robot.brain.get("global.petitionsMadeTodayByLocation")
  petitionsMadeTodayByLocation = storedPetitionsList if storedPetitionsList and not petitionListIsDirty

syncPetitionsList = (robot) ->
  robot.brain.set("global.petitionsMadeTodayByLocation", petitionsMadeTodayByLocation)
  robot.brain.save()
  petitionListIsDirty = false

clearPetitions = (robot, res) ->
  channel = res.message.room
  robot.brain.set(channel + ".petitions.food_type", null)
  robot.brain.set(channel + ".petitions.distance_preference", null)
  robot.brain.save();
  
module.exports = (robot) ->
  robot.respond /who am i\?/i, (res) ->
    res.reply(res.message.user.name)
  
  robot.respond /where am i\?/i, (res) ->
    res.reply(res.message.room)

  robot.respond /show me your faithful/, (res) ->
    waitASec
    shoreUpPetitionsList(robot)
    res.send("```" + JSON.stringify(petitionsMadeTodayByLocation, null, "\t") + "```")

  robot.respond /i pray for (.*) food/i, (res) ->
    if canPetition(robot, res)
      makePetition(robot, res)
      foodType = res.match[1]
      if (Math.random() < PRAYER_PROBABILITY)
        robot.brain.set("prayers.food_type", foodType)
        res.reply "THOUST PRAYER HATH BEEN HEARD"
      else
        res.reply "THOUST PRAYERS HATH GONE UNANSWERED"
    else
      res.reply "BEWARE GREED, MY CHILD"
  
  robot.hear /I listen to you/i, (msg) ->
    sleep(4000)
    msg.send msg.random listenUrls

  robot.respond /show me the history/i, (res) ->
    channel = res.message.room
    channelKey = "#{channel}.history"
    history = robot.brain.get(channelKey) || []
    res.send JSON.stringify(history)

  robot.respond /init/, (res) ->
    waitASec
    robot.brain.set('prayrecord',testPrays)
    robot.brain.save()
    record = robot.brain.get('prayrecord')['Banditos']
    res.reply "Banditos #{record}."
  robot.respond /dev.ping/, (res) ->
    waitASec
    res.send omniscience.ping()

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
    res.send res.random listenUrls
    sleep(3000)
    user = res.message.user.name
    location = robot.brain.get("#" + channel.toLowerCase())
    if location
      clearDailyPetitionsByChannel(robot, res)
      clearPetitions(robot, res)
      lunchMe(robot, res, location, "food")
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

sleep = (ms) ->
  start = new Date().getTime()
  continue while new Date().getTime() - start < ms

waitASec = () ->
  sleep(Math.floor(Math.random() * (1500 - 500)) + 500)

