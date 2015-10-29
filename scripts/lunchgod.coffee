enterReplies = ['*A new disciple comes to Me.*', '*Join the flock and be fed.*', '*Come unto Me*', '*Witness My glory!*']
leaveReplies = ['*Thou art excommunicated.*', '*Why hast thou forsaken Me?*', '*I cast thee out!*', '*BLASHPEMER!*']

vengefulPics = [
  "http://kitcampbell.com/wp-content/uploads/2013/09/spilt-milk-for-web.jpg", # Spilt Milk
  "http://sites.psu.edu/brownandblueatpsutwo/wp-content/uploads/sites/14654/2014/09/broken-pencil.jpg", # Broken Pencil
  "http://i1.mirror.co.uk/incoming/article2253524.ece/ALTERNATES/s1200/Slice-of-toast-with-strawberry-jam-upside-down-on-floor.jpg", # Jam on floor
  "http://www.nirsoft.net/utils/bluescreen1.gif", # Blue Screen
  "http://cdn.sheknows.com/articles/2013/07/Mike/SK/Dog-sitting-chewe-up-mess.jpg", # Bad Dog
  "http://online.thatsmags.com/uploads/content/1406/4317/toiletRoll_2441938b.jpg", # Out of Toilet Paper
  "https://tribwgntv.files.wordpress.com/2015/07/parkingticket.jpg?w=640", # Parking Ticket
  "http://seanamarasinghe.com/wp-content/uploads/2015/01/coffeescript-jquery-600x360.png", # CoffeeScript
  "http://pictures.dealer.com/c/checkeredflag/1270/cec6218e0a0d02b701019275346b7fe5.png", # Bad Traffic
  "http://www.pumptalk.ca/images/2012_Post_Images/PumpTalkPost_03_1_2012_PHOTO.JPG", # Out of Gas
  "http://loadstorm.com/files/Car_sliced_by_a_Tree_downed_by_a_Tornado.jpg", # Tree on Car
  "http://cdn.zmescience.com/wp-content/uploads/2012/05/thundercloud-storm.jpg", # Storm Clouds
  "http://biblemesh.com/blog/wp-content/uploads/2013/06/tornado2.jpg", # Stormier Clouds
  "http://www.scienceclarified.com/photos/thunderstorm-3033.jpg", # Thunder Storm
  "https://www.ok.gov/oid/images/tornado.jpg", # Tornado
  "http://msnbcmedia.msn.com/j/MSNBC/Components/Photo/_new/pb-110905-fires-da-02.photoblog900.jpg", # Wildfire
  "http://www.blog-n-play.com/wp-content/uploads/2015/06/040620-120317-inq-flood.jpg", # Flood
  "http://blogs.agu.org/landslideblog/files/2015/06/15_06-Malaysia-3.jpg", # Earthquake
  "http://graphics8.nytimes.com/images/2007/04/29/us/collapse2.600..jpg", # Bridge Collapse
  "http://img.izismile.com/img/img3/20100408/640/swarms_of_different_640_19.jpg", # Locusts
  "http://strangesounds.org/wp-content/uploads/2015/04/natural-disaster-video.jpg", # Tsunami
  "http://imgc.allpostersimages.com/images/P-473-488-90/38/3880/2WZJF00Z/posters/mike-theiss-palm-trees-blasted-by-winds-over-100-mph-during-hurricane-wilma.jpg", # Hurricane Winds
  "http://images.nationalgeographic.com/wpf/media-live/photos/000/002/cache/hurricane-ivan_200_600x450.jpg", # Hurricane from space
  "http://www.standeyo.com/NEWS/07_Earth_Changes/07_Earth_Change_pics/070316.Popocatepetl.jpg", # Volcano with Ash
  "http://www.noahmintz.com/volcano.jpg", # Volcano with Fire
  "http://i.kinja-img.com/gawker-media/image/upload/s--C3EUsPuw--/17mt53o7rtznrjpg.jpg", # Volcano with Fire and Lightning
  "https://marciokenobi.files.wordpress.com/2012/12/end-of-the-world-3.jpg", # Nuke
  "http://www.paulickreport.com/wp-content/uploads/2015/07/zombies.jpg", # Zombies
  "http://africarm.org/site/wp-content/uploads/2014/01/illustration-of-noahs_ark.jpg", # Noah's Ark
  "http://beforeitsnews.com/contributor/upload/427270/images/prophecy.jpg", # Hellfire
  "http://img08.deviantart.net/ef26/i/2009/332/e/2/the_end_of_the_world_by_0bo.jpg", # Giant Demon
  "http://www.isciencemag.co.uk/wp-content/uploads/2011/06/Meteorite-impact.jpg", # Meteorite Impact
  "http://i.telegraph.co.uk/multimedia/archive/02433/_end-of-the-world_2433119b.jpg" # Earth Explodes
]

maxBless = process.env.BLESS_RANGE
minBless = process.env.BLESS_RANGE * -1
DENOUNCE_COUNT = process.env.DENOUNCE_COUNT

REST_TIME = parseInt(process.env.LUNCHGOD_REST_TIME)
PRAYER_PROBABILITY = process.env.PRAYER_PROBABILITY
MAX_HISTORY = process.env.MAX_HISTORY
FORCE_OLD_TESTAMENT_MODE = process.env.FORCE_OLD_TESTAMENT_MODE
DISABLE_OLD_TESTAMENT_MODE = process.env.DISABLE_OLD_TESTAMENT_MODE

range = (maxBless - minBless)

consumer_key = "QbaOtI4HhOIheBXDgL9Miw"
consumer_secret = "cyVWY4CZJ-o9hPw3XuAxRQbe3YE"
token = "UapxC4VIu4D7P6Wqpa8NK8OQLCoclwhb"
token_secret = "PRQtr_R-GmEffFPTkZ0qSGxR_ic"

# Default search parameters
RADIUS = process.env.RADIUS
sort = 0

trim_re = /^\s+|\s+$|[\.!\?]+$/g

# Create the API client
yelp = require("yelp").createClient consumer_key: consumer_key, consumer_secret: consumer_secret, token: token, token_secret: token_secret


lunchMe = (robot, res, location, query) ->
  if isOldTestamentMode(robot, res)
    if FORCE_OLD_TESTAMENT_MODE == "false" and DISABLE_OLD_TESTAMENT_MODE == "false" and isOldTestamentMode(robot, res)
      reduceOldTestament(robot, res)
    return res.send("*Enjoy thine myocardial infarction -- Frita Batidos*\nhttp://www.yelp.com/biz/frita-batidos-ann-arbor")
  
  # Clean up the query
  query = getPetition(robot, res, "preference") if not query
  query = "food" if not query
  query = query.replace(trim_re, '')
  query = "food" if query == ""
  
  # Dietary restrictions
  if res.match[1]
    recognizedDietaryRestriction = false
    dietaryRestrictionText = res.match[1].trim()
    for regexp in DIETARY_RESTRICTIONS
      if (dietaryRestrictionText.match(regexp))
        query += " " + dietaryRestrictionText
        recognizedDietaryRestriction = true
        break;
        
    if not recognizedDietaryRestriction
      res.send("*Thine dietary restriction are not My concern*")
  
  console.log("@@@using query \"#{query}\" for @#{res.message.room}")
  myRadius = RADIUS
    
  # Perform the search
  #msg.send("Looking for #{query} around #{location}...")
  yelp.search category_filter: "restaurants", term: query, radius_filter: myRadius, sort: sort, limit: 20, location: location, (error, data) ->
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
    channelHistoryKey = "#{channel}.history"
    history = robot.brain.get(channelHistoryKey) || []
    channelDenounceKey = "#{channel}.denounceCount"
    if (location.is_closed == false && location.name not in history && (blessing + maxBless)/range >= Math.random())
      history.push(location.name)
      if history.length > MAX_HISTORY
        history.shift()
      robot.brain.set(channelHistoryKey, history)
      robot.brain.set(channelDenounceKey, 0)
      robot.brain.save()
      return "*On this day, thou shalt go unto " + location.name + " and be fed.*\n" + location.url
    else
      return weightedRandom(robot, res, data)
  else
    return "....."

todaysPetitioners = {}
petitionersLocked = false

PETITION_TYPES = [
  "preference"
]

PRAYERS = [
  {
    petitionType: "preference",
    
    regularExpressions: [
      /(?:(?:(?:(?:i +am)|(?:i'?m)|(?:we +are)|(?:we'?re)) +(?:(?:(?:(?:in +the +mood)|(?:hungry)) +for)|(?:craving)|(?:feeling)))|(?:(?:(?:i)|(?:we))(?:(?:(?: +have)|(?:'?ve +got)) +a +hankering +for)|(?: +could +go +for)|(?: +want)|(?:(?:(?:'?d)|(?: +would)) +(?:(?:like)|(?:prefer))))|(?:(?:(?:i)|(?:we)) +feel +like))(?: +(?:(?:some)|(?:a)))? +(.+)/i 
    ],
    
    handler: null
  }
]

DIETARY_RESTRICTIONS = [
  /^gluten.free$/i
]

getPetition = (robot, res, petitionType) ->
  return robot.brain.get(res.message.room + ".petitions." + petitionType)

setPetitionNoSave = (robot, res, petitionType, value) ->
  robot.brain.set(res.message.room + ".petitions." + petitionType, value)

setPetition = (robot, res, petitionType, value) ->
  setPetitionNoSave(robot, res, petitionType, value)
  robot.brain.save()

makePetition = (robot, res, user) ->
  channel = res.message.room
  user = user || res.message.user.name
  
  if not canPetition(robot, res)
    return false

  shoreUpPetitioners(robot)
  petitionersLocked = true

  petitions = todaysPetitioners[channel]

  if not petitions
    petitions = []
    todaysPetitioners[channel] = petitions

  petitions.push user
  syncPetitioners(robot)
  return true

canPetition = (robot, res) ->
  channel = res.message.room
  user = res.message.user.name
  shoreUpPetitioners(robot)
  petitions = todaysPetitioners[channel] or []
  return user not in petitions

clearPetitionersByChannel = (robot, res) ->
  channel = res.message.room
  shoreUpPetitioners(robot)
  petitionersLocked = true
  todaysPetitioners[channel] = []
  syncPetitioners(robot)
  
shoreUpPetitioners = (robot) ->
  storedPetitionsList = robot.brain.get("global.todaysPetitioners")
  todaysPetitioners = storedPetitionsList if storedPetitionsList and not petitionersLocked

syncPetitioners = (robot) ->
  robot.brain.set("global.todaysPetitioners", todaysPetitioners)
  robot.brain.save()
  petitionersLocked = false

clearPetitions = (robot, res) ->
  setPetition(robot, res, petitionType, null) for petitionType in PETITION_TYPES

getVengenceLevel = (robot, res) ->
  level = robot.brain.get(res.message.room + ".vengence")
  if not level
    randomizeVengence(robot, res)
    return getVengenceLevel(robot, res)
  else
    return level

randomizeVengence = (robot, res) ->
  maximum = vengefulPics.length - 1
  robot.brain.set(res.message.room + ".vengence", Math.floor(Math.random() * maximum))
  if DISABLE_OLD_TESTAMENT_MODE == "false" and not isOldTestamentMode(robot, res) and (Math.random() < 1 / 365)
    startOldTestamentMode(robot, res)
  robot.brain.save()

isOldTestamentMode = (robot, res) ->
  return false if DISABLE_OLD_TESTAMENT_MODE == "true"
  return true if FORCE_OLD_TESTAMENT_MODE == "true"
  return parseInt(robot.brain.get(res.message.room + ".oldTestament") || "0") > 0

startOldTestamentMode = (robot, res) ->
  robot.brain.set(res.message.room + ".oldTestament", 10)
  robot.brain.save()
  
reduceOldTestament = (robot, res) ->
  newVal = parseInt(res.message.room + ".oldTestament" || "0") - 1
  newVal = 0 if newVal < 0
  
  robot.brain.set(res.message.room + ".oldTestament", newVal)
  robot.brain.save()

parsePrayer = (robot, res, prayerText) ->
  for prayer in PRAYERS
    for regex in prayer.regularExpressions
      match = prayerText.match(regex)
      if match and match.length == 2
        runPrayer(robot, res, prayer, prayerText, match[1])
        return
  
  res.reply "*Thine words art blaphemous*"

runPrayer = (robot, res, prayer, prayerText, prayerSubject) ->
  if canPetition(robot, res)
    makePetition(robot, res)
    if (Math.random() <= PRAYER_PROBABILITY)
      console.log("@@@accepted prayer from #{res.message.user.name}@#{res.message.room}")
      if prayer.handler
        console.log("@@@using custom prayer handler for #{res.message.user.name}@#{res.message.room}'s prayer \"#{prayerText}\"")
        prayer.handler(robot, res, prayerText, prayerSubject)
      else
        console.log("@@@@#{res.message.room} now has a #{prayer.petitionType} for \"#{prayerSubject}\"")
        setPetition(robot, res, prayer.petitionType, prayerSubject)
        
      res.reply "*Thine prayers hath been heard*"
    else
      console.log("@@@rejected prayer from #{res.message.user.name}@#{res.message.room} for \"prayerText\"")
      res.reply "*Thine prayers hath gone unanswered*"
  else
    res.reply "*Beware my wrath, my child*"
  
module.exports = (robot) ->
  robot.respond /(?:, +)?who am i\?/i, (res) ->
    res.reply(res.message.user.name)
  
  robot.respond /(?:, +)?where (?:(?:am i)|(?:are we))\?/i, (res) ->
    res.reply(res.message.room)
  
  robot.respond /(?:, +)?hear +(?:(?:my)|(?:our)) +prayers?[.,:!;]? +(.*)/i, (res) ->
    waitASec
    parsePrayer(robot, res, res.match[1])
  
  robot.hear /denounce/i, (res) ->
    channel = res.message.room
    channelDenounceKey = "#{channel}.denounceCount"
    if canPetition(robot, res)
      res.send "*Thine dissent hath been noted.*"
      denounceCount = robot.brain.get(channelDenounceKey)
      makePetition(robot, res)
      denounceCount += 1
      if denounceCount >= DENOUNCE_COUNT
        location = robot.brain.get("#" + channel.toLowerCase())
        lunchMe(robot, res, location, "food")
      else
        robot.brain.set(channelDenounceKey, denounceCount)
        robot.brain.save()

  robot.respond /(?:, +)?sayeth +our +history/i, (res) ->
    channel = res.message.room
    channelKey = "#{channel}.history"
    history = robot.brain.get(channelKey) || []
    res.send history.reverse().join(", ")

  robot.respond /(?:, +)?smite ([^ ]+)/i, (res) ->
    if canPetition(robot, res)
      user = res.match[1]
      makePetition(robot, res, user)
      makePetition(robot, res)
      res.send "*I smite thou #{user}*"

  robot.respond /(?:, +)?how +vengeful +art +Thou\?/i, (res) ->
    index = getVengenceLevel(robot, res)
    res.send vengefulPics[index]

  robot.respond /(?:, +)?bless +(.*)/, (res) ->
    waitASec()
    if canPetition(robot, res)
      makePetition(robot, res)
      target = res.match[1]
      blessings = robot.brain.get(target.toLowerCase()) || 0
      if blessings < maxBless
        robot.brain.set(target.toLowerCase(), blessings + 1)
        robot.brain.save()
      res.send "*Blessed art #{target}.*"

  robot.respond /(?:, +)?curse +(.*)/i, (res) ->
    waitASec()
    if canPetition(robot, res)
      makePetition(robot, res)
      target = res.match[1]
      blessings = robot.brain.get(target.toLowerCase()) || 0
      if blessings > minBless
        robot.brain.set(target.toLowerCase(), blessings - 1)
        robot.brain.save()
      res.send "*Cursed art #{target}.*"

  robot.respond /(?:, +)?how +blessed +art (.*)\?/i, (res) ->
    waitASec()
    target = res.match[1]
    blessings = robot.brain.get(target.toLowerCase()) || 0
    if blessings == 0
      res.send "*#{target} art profane.*"
    else if blessings == maxBless
      res.send "*#{target} art holy.*"
    else if blessings == minBless
      res.send "*#{target} art excommunicated.*"
    else if blessings > 0
      res.send "*#{target} art blessed.*"
    else if blessings < 0
      res.send "*#{target} art cursed.*"

  robot.respond /(?:, +)?help/i, (res) ->
    waitASec()
    res.send "*The 10 Commands*\n1. SHOW US THE WAY!\n2. Bless [RESTAURANT]\n3. Curse [RESTAURANT]\n4. How blessed art [RESTAURANT]?\n5. We dwell in/at [LOCATION]\n6. Hear my prayers: I am in the mood for [SOMETHING]\n7. How vengeful art Thou?\n8. Smite [PERSON]\n9. I denounce it\n10. Sayeth our history"

  robot.respond /(?:, +)?we dwell ((?:in)|(?:at)) (.*)/i, (res) ->
    waitASec()
    location = res.match[2]
    channel = "#" + res.message.room
    robot.brain.set(channel.toLowerCase(), location)
    robot.brain.save()
    res.send "*Henceforth My hearty aroma shalt waft upon #{location}*"

  robot.respond /(?:, +)?show +us +the(?: +(.+))? +way[!]?/, (res) ->
    waitASec()
    res.send "*I cannot hear thou.*"

  robot.respond /(?:, +)?SHOW +US +THE(?: +(.+))? +WAY!/, (res) ->
    waitASec()
    channel = res.message.room
    location = robot.brain.get("#" + channel.toLowerCase())
    if location
      if doWork(robot, res)
        res.send "http://media.giphy.com/media/KJYUwoRXeQGxW/giphy.gif"
        lunchMe(robot, res, location)
        clearPetitionersByChannel(robot, res)
        clearPetitions(robot, res)
        randomizeVengence(robot, res)
      else
        res.send "*I am resting...*"
    else
      res.send "*Where dost thou dwell?*"

  robot.hear /.+ lunch[ ]?god/i, (res) ->
    waitASec()
    res.reply "*Thou shalt not take My Name in vain!*"

  robot.respond /(?:, +)?nyan/, (res) ->
    waitASec()
    res.send "http://www.cc.gatech.edu/~hays/compvision/results/proj1/dpuleri3/hybrid_gif/nyanCat.gif"

  robot.enter (res) ->
    waitASec()
    res.reply res.random enterReplies

  robot.leave (res) ->
    waitASec()
    res.reply res.random leaveReplies

sleep = (ms) ->
  start = new Date().getTime()
  continue while new Date().getTime() - start < ms

waitASec = () ->
  sleep(Math.floor(Math.random() * (1500 - 500)) + 500)

doWork = (robot, res) ->
  now = new Date().getTime()
  channel = res.message.room
  channelKey = "#{channel}.lastRun"
  lastRun = parseInt(robot.brain.get(channelKey)) || 0
  if lastRun + REST_TIME > now
    return false
  else
    robot.brain.set(channelKey, now)
    robot.brain.save()
    return true
