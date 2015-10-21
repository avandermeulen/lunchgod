omniscience = require("omniscience");

enterReplies = ['A new disciple comes to Me.', 'Join the flock and be fed.', 'Come unto Me']
leaveReplies = ['Thou art excommunicated.', 'Why hast thou forsaken Me?', 'I cast thee out!']

module.exports = (robot) ->
  robot.respond /ping/, (res) ->
    res.send omniscience.ping()
    
  robot.respond /bless (.*)/, (res) ->
    target = res.match[1]
    blessings = robot.brain.get(target.toLowerCase()) || 0
    robot.brain.set(target.toLowerCase(), blessings + 1)
    res.send "Blessed art #{target}."
    robot.brain.save()

  robot.respond /curse (.*)/, (res) ->
    target = res.match[1]
    blessings = robot.brain.get(target.toLowerCase()) || 0
    robot.brain.set(target.toLowerCase(), blessings - 1)
    res.send "Cursed art #{target}."
    robot.brain.save()

  robot.respond /how blessed art (.*)\?/, (res) ->
    target = res.match[1]
    blessings = robot.brain.get(target.toLowerCase()) || 0
    if blessings == 1
      res.send "A single blessing upon #{target}."
    else if blessings == -1
      res.send "A single curse upon #{target}."
    else if blessings < -1
      curses = blessings * -1
      res.send "#{curses} curses upon #{target}."
    else if blessings > 1
      res.send "#{blessings} blessings upon #{target}."
    else if blessings == 0
      res.send "#{target} is neutral in My eyes."

  robot.hear /.+ lunch[ ]?god/i, (res) ->
    name = res.message.user.name
    res.send "@#{name}: Thou shalt not take My Name in vain!"

  robot.enter (res) ->
    name = res.message.user.name
    res.send "@#{name}: " + res.random enterReplies
  robot.leave (res) ->
    name = res.message.user.name
    res.send "@#{name}: " + res.random leaveReplies
