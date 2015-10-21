###############################################################################
##      OMNISCIENCE JS
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
                "name": "tios",
            }
        ];
    }
};
`
##
###############################################################################

enterReplies = ['A new disciple comes to Me.', 'Join the flock and be fed.', 'Come unto Me']
leaveReplies = ['Thou art excommunicated.', 'Why hast thou forsaken Me?', 'I cast thee out!']

testList = ['Banditos', 'TK Wu', 'Broken Egg', 'Grizzly Peak', 'Blue Tractor']

maxBless = 10
minBless = -10

module.exports = (robot) ->
  robot.respond /dev.ping/, (res) ->
    res.send omniscience.ping()
  
  robot.respond /dev.list (.*)/, (res) ->
    location = res.match[1]
    res.send("```" + JSON.stringify(omniscience.list(location), null, "\t") + "```")
    
  robot.respond /bless (.*)/, (res) ->
    target = res.match[1]
    blessings = robot.brain.get(target.toLowerCase()) || 0
    if blessings < maxBless
      robot.brain.set(target.toLowerCase(), blessings + 1)
      robot.brain.save()
    res.send "Blessed art #{target}."

  robot.respond /curse (.*)/, (res) ->
    target = res.match[1]
    blessings = robot.brain.get(target.toLowerCase()) || 0
    if blessings > minBless
      robot.brain.set(target.toLowerCase(), blessings - 1)
      robot.brain.save()
    res.send "Cursed art #{target}."

  robot.respond /how blessed art (.*)\?/, (res) ->
    target = res.match[1]
    blessings = robot.brain.get(target.toLowerCase()) || 0
    if blessings == 0
      res.send "#{target} art neutral."
    else if blessings == maxBless
      res.send "#{target} art divine."
    else if blessings == minBless
      res.send "#{target} art excommunicated."
    else if blessings > 0
      res.send "#{target} art blessed."
    else if blessings < 0
      res.send "#{target} art cursed."
  
  robot.respond /show us the way[!]?/, (res) ->
    res.send "I can not hear thou."

  robot.respond /SHOW US THE WAY!/, (res) ->
    res.send "404, omniscience not found"

  robot.hear /.+ lunch[ ]?god/i, (res) ->
    name = res.message.user.name
    res.send "@#{name}: Thou shalt not take My Name in vain!"

  robot.enter (res) ->
    name = res.message.user.name
    res.send "@#{name}: " + res.random enterReplies
  robot.leave (res) ->
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

