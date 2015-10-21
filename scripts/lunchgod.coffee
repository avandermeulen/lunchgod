enterReplies = ['A new disciple comes to Me.', 'Join the flock and be fed.']
leaveReplies = ['Thou art excommunicated.', 'Why hast thou forsaken Me?']

module.exports = (robot) ->
  robot.respond /bless (.*)/, (res) ->
    target = res.match[1]
    res.send "Blessed art #{target}."

  robot.enter (res) ->
    res.send res.random enterReplies
  robot.leave (res) ->
    res.send res.random leaveReplies
