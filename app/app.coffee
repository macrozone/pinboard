

@Articles = new Meteor.Collection "articles"
@Articles.attachSchema new SimpleSchema
	title:
		type: String
		index: 1
		label: "Title"
	text:
		type: String
		autoform: 
			rows: 10
	createdAt: 
		autoform: omit: true
		type: Date
		index: -1
		autoValue: ->
			if @isInsert
				new Date
			else if @isUpsert
				$setOnInsert: new Date
			else
				@unset()

	updatedAt:
		autoform: omit: true
		type: Date
		index: -1
		autoValue: ->
			new Date if @isUpdate
		denyInsert: true
		optional: true 
	size:
		type: String
		allowedValues: ['s', 'm', 'l']
		autoform:
			options:[
				(label: 'Small', value: 's')
				(label: 'Medium', value: 'm')
				(label: 'Large', value: 'l')
			]
				





