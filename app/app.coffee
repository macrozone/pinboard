

@Articles = new Meteor.Collection "articles"


if Meteor.isServer
	Meteor.methods
		"shuffle": ->
			count = Articles.find().count()
			newOrder = _.shuffle [1..count]
			Articles.find({}).forEach (article, index) ->
				Articles.update article._id, $set: order: newOrder[index]