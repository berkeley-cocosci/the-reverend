# Description:
#   Tell the reverend where you're working on so he can tell others.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   reverend i'm at <anything> - Set where you're working.
#   reverend where is everyone? - Find out where everyone is.
#
# Author:
#   suchow

module.exports = (robot) ->

  robot.respond /(?:where\'s|where is|wheres|where are) @?([\w .\-]+)(?:\?)?$/i, (msg) ->
    name = msg.match[1].trim()

    if name is "you" or robot.name.toLowerCase()
      msg.send "Probably still in Bunhill Fields, just north of London, where I was buried."
    else if name.toLowerCase()
      msg.send "Nobody really knows."
    else if name.match(/(everybody|everyone|every one|every body|people)/i)
      messageText = '';
      users = robot.brain.users()
      for k, u of users
          if u.workingat
              messageText += "#{u.name} is at #{u.workingat}\n"
          else
              messageText += ""
      if messageText.trim() is "" then messageText = "Nobody told me a thing."
      msg.send messageText
    else
      users = robot.brain.usersForFuzzyName(name)
      if users.length is 1
        user = users[0]
        user.workingat = user.workingat or [ ]
        if user.workingat.length > 0
          msg.send "#{name} is working at #{user.workingat}."
        else
          msg.send "#{name} is floating in the æther."
      else if users.length > 1
        msg.send getAmbiguousUserText users
      else
        msg.send "#{name}? Who's that?"

  robot.respond /(?:i\'m|i am|im) (at|in|inside) (.*)/i, (msg) ->
    name = msg.message.user.name
    user = robot.brain.userForName name

    if typeof user is 'object'
      user.workingat = msg.match[1]
      msg.send "Okay #{user.name}, got it."
    else if typeof user.length > 1
      msg.send "I found #{user.length} people named #{name}"
    else
      msg.send "I don't really know you, #{name}"
