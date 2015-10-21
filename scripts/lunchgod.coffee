enterReplies = ['A new disciple comes to Me.', 'Join the flock and be fed.', 'Come unto Me']
leaveReplies = ['Thou art excommunicated.', 'Why hast thou forsaken Me?', 'I cast thee out!']

module.exports = (robot) ->
  robot.respond /bless (.*)/, (res) ->
    target = res.match[1]
    blessings = robot.brain.get(target) || 0
    robot.brain.set(target, blessings + 1)
    res.send "Blessed art #{target}."

  robot.respond /howed bessed art (.*)?/, (res) ->
    target = res.match[1]
    blessings = robot.brain.get(target) || 0
    if blessings is 1
      res.send "A single blessing upon #{target}."
    else
      res.send "#{blessings} blessings upon #{target}."

  robot.enter (res) ->
    name = res.message.user.name
    res.send "@#{name}: " + res.random enterReplies
  robot.leave (res) ->
    name = res.message.user.name
    res.send "@#{name}: " + res.random leaveReplies
