enterReplies = ['A new disciple comes to Me.', 'Join the flock and be fed.']
leaveReplies = ['Thou art excommunicated.', 'Why hast thou forsaken Me?']

module.exports = (robot) ->
  robot.respond /bless (.*)/, (res) ->
    target = res.match[1]
    res.send "Blessed art #{target}."

  robot.enter (res) ->
    name = res.message.user.name
    res.send "@#{name}: " + res.random enterReplies
  robot.leave (res) ->
    name = res.message.user.name
    res.send "@#{name}: " + res.random leaveReplies
