BOARD_SELECTOR = ".board"

Router.map ->
	@route "home", 
		path: "/"
		data: ->
			articles: Articles.find {},  {sort: {createdAt: -1}}
		




Template.home.rendered = ->
	pckry = new Packery @find BOARD_SELECTOR

	$grid = @$(BOARD_SELECTOR)

	layout = ->
		$grid.packery "destroy"
		$grid.packery( )
		$grid.find "article .content"
		.okshadow()
			
	@autorun =>
		Meteor.setTimeout layout, 1000
		Articles.find({},  {sort: {createdAt: -1}}).count()

		console.log "update"
	

Template.article_box.events
	"click article:not(.editMode)": (event, template) ->

		$target = $(event.currentTarget)
		
		expanded = $target.hasClass("expanded")
		$(event.target).closest(BOARD_SELECTOR).find("article").not($target).removeClass "expanded"
		$target.toggleClass "expanded"
		Session.set "editArticle", ""
		if expanded
	
			# if shrinking, just layout
			$(event.target).closest(BOARD_SELECTOR).packery()
	
		else
			$(event.target).closest(BOARD_SELECTOR).packery "fit", $target.get 0


	"click .btn-update": (event, template)->
		if Session.get("editArticle") == template.data._id
			Session.set "editArticle", ""
		else
			Session.set "editArticle", template.data._id
			Meteor.setTimeout ->
				$(event.target).closest(BOARD_SELECTOR).packery()
			, 300
		return false


Template.article_box.editMode = ->
	
	@_id == Session.get("editArticle")


Template.article_box.sizeClasses = ->
	switch @size
		when 'l' then 'col-xs-12 col-sm-12 col-md-6 col-lg-6'
		when 's' then 'col-xs-6 col-sm-3 col-md-2 col-lg-2'
		else 'col-xs-6 col-sm-6 col-md-4 col-lg-4'

