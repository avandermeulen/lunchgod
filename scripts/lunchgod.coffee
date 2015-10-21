module.exports = (robot) ->
  robot.respond /bless (@[^ ]+)/, (res) ->
    target = res.match[1]
    res.send "#{target} art thou blessed"
