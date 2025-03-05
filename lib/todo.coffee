import {Meteor} from 'meteor/meteor'
import {Mongo} from 'meteor/mongo'
import {check} from 'meteor/check'

export ToDo = new Mongo.Collection 'todo'

console.log 'Using CoffeeScript library.'

if Meteor.isServer
  # Each user name has a to-do list.  Index and subscribe by name.
  ToDo.createIndex name: 1
  Meteor.publish 'todo', (name) ->
    check name, String
    ToDo.find {name}

Meteor.methods
  'todo.add': (name, title) ->
    check name, String
    check title, String
    if Meteor.isServer
      await ToDo.insertAsync {name, title, created: new Date}
    else
      ToDo.insert {name, title, created: new Date}
  'todo.del': (id) ->
    check id, String
    if Meteor.isServer
      await ToDo.removeAsync _id: id
    else
      ToDo.remove _id: id
