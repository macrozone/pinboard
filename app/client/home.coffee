Router.map ->
	@route "home", 
		path: "/"
		data: ->
			articles: Articles.find {},  {sort: {itime: -1}}
		




Template.home.rendered = ->
	pckry = new Packery @find ".grid"

	$grid = @$(".grid")

	layout = ->
		$grid.packery "destroy"
		$grid.packery( )
		#$grid.find "article .content"
		#.okshadow()
			
	@autorun =>
		Meteor.setTimeout layout, 1000
		Articles.find({},  {sort: {itime: -1}}).count()

		console.log "update"
	

Template.article_box.events
	"click article:not(.editMode)": (event, template) ->

		$target = $(event.currentTarget)
		
		expanded = $target.hasClass("expanded")
		$(event.target).closest(".grid").find("article").not($target).removeClass "expanded"
		$target.toggleClass "expanded"
		Session.set "editArticle", ""
		if expanded
	
			# if shrinking, just layout
			$(event.target).closest(".grid").packery()
	
		else
			$(event.target).closest(".grid").packery "fit", $target.get 0


	"click .btn-update": (event, template)->
		if Session.get("editArticle") == template.data._id
			Session.set "editArticle", ""
		else
			Session.set "editArticle", template.data._id
			Meteor.setTimeout ->
				$(event.target).closest(".grid").packery()
			, 300
		return false


Template.article_box.editMode = ->
	
	@_id == Session.get("editArticle")


Template.article_box.sizeClasses = ->
	switch @size
		when 'l' then 'col-xs-12 col-sm-12 col-md-6 col-lg-6'
		when 's' then 'col-xs-6 col-sm-3 col-md-2 col-lg-2'
		else 'col-xs-6 col-sm-6 col-md-4 col-lg-4'

