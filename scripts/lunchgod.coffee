###############################################################################
##      OMNISCIENCE JS
##
`
var omniscience =
{
    "ping": function()
    {
        return "I AM AWAKE";
    },

    "list": function(location)
    {
        // TODO
        return [
            {
                "name": "tios"
            },

            {
                "name": "banditos"
            },

            {
                "name": "grizzly peak"
            },

            {
                "name": "broken egg"
            }
        ];
    }
};

`
##
###############################################################################

###############################################################################
##      OMNIPOTENCE COFFESCRIPT
##
enterReplies = ['A new disciple comes to Me.', 'Join the flock and be fed.', 'Come unto Me']
leaveReplies = ['Thou art excommunicated.', 'Why hast thou forsaken Me?', 'I cast thee out!']

testList = ['Banditos', 'TK Wu', 'Broken Egg', 'Grizzly Peak', 'Blue Tractor']

maxBless = 10
minBless = -10
maxPray = 5
minPray = -5

testData = require('data.coffee').testData

module.exports = (robot) ->
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
    res.send "Prayed art #{testData}."

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
      res.send "#{target} art neutral."
    else if blessings == maxBless
      res.send "#{target} art holy."
    else if blessings == minBless
      res.send "#{target} art excommunicated."
    else if blessings > 0
      res.send "#{target} art blessed."
    else if blessings < 0
      res.send "#{target} art cursed."

  robot.respond /show us the way[!]?/, (res) ->
    waitASec
    res.send "I can not hear thou."

  robot.respond /SHOW US THE WAY!/, (res) ->
    waitASec
    res.send weightedRandom(testList)

  robot.hear /.+ lunch[ ]?god/i, (res) ->
    waitASec
    name = res.message.user.name
    res.send "@#{name}: Thou shalt not take My Name in vain!"

  robot.enter (res) ->
    waitASec
    name = res.message.user.name
    res.send "@#{name}: " + res.random enterReplies

  robot.leave (res) ->
    waitASec
    name = res.message.user.name
    res.send "@#{name}: " + res.random leaveReplies

  weightedRandom = (list) ->
    index = Math.floor(Math.random() * list.length)
    location = list[index]
    blessing = robot.brain.get(location.toLowerCase()) || 0
    if ((blessing + 10)/20 >= Math.random())
      return location
    else
      return weightedRandom(list)

waitASec = () ->
  sleep(Math.floor(Math.random() * (1000 - 200)) + 200)


##
###############################################################################
