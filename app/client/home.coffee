Router.map ->
	@route "home", 
		path: "/"
		data: ->
			articles: Articles.find {},  {sort: {order: 1}}


Template.home.rendered = ->
	Meteor.setTimeout ->
		@$(".grid").masonry
			itemSelector: "article"
	, 100

Template.home.sizeClasses = ->
	switch @size
		when 'l' then 'col-xs-12 col-sm-12 col-md-6 col-lg-6'
		when 's' then 'col-xs-6 col-sm-3 col-md-2 col-lg-2'
		else 'col-xs-6 col-sm-6 col-md-4 col-lg-4'

