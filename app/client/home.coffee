

Router.map ->
	@route "home", 
		path: "/"
		yieldTemplates:
			home_nav: to: "headerNavigationRight"
		data: ->
			articles: Articles.find {}, sort: position: 1
			showEditor: Session.get "showEditor"
			defaultGridSizeClasses: Constants.getSizeClasses "s"



addBox = (size) ->
	
	position = Articles.findOne({}, sort: position: 1)?.position
	unless position? 
		position = 0
	else
		position--
	Articles.insert 
		size: size
		position: position
Template.home_nav.events
	"click .btn-toggle-editor": ->
		Session.set "showEditor", !Session.get "showEditor"
	"dragstart .btn-add-box": (event)->
		event.originalEvent.dataTransfer.setData "size", $(event.currentTarget).data "size"
	"click .btn-add-box": (event)->
		console.log $(event.currentTarget).data "size"
		addBox $(event.currentTarget).data "size"
	"dropped .trash-area": (event) ->
		console.log event
		console.log event.originalEvent?.dataTransfer?.getData 'article_id'

Template.home.events
	"dropped .board": (event, template) ->
		console.log event
		size =  event.originalEvent?.dataTransfer?.getData 'size'
		position = template.data.position
		addBox size

Template.home.rendered = ->



	$board = @$(Constants.BOARD_SELECTOR)
	$board.packery
		"itemSelector": "article"
		"columnWidth": ".grid-sizer"
	$board.packery "on", "dragItemPositioned", (packery)->
		for item, index in packery.items
			Articles.update {_id: item.element.id}, $set: position: index

	$board.packery "on", "layoutComplete", (packery, items)->
		for item in items
			$article = $ item.element

			if $article.hasClass "notInit"
				
				$article.removeClass "notInit"
				$article.addClass "init"
				
				draggie = new Draggabilly item.element,
					handle: ".content.static"

				draggie.on "dragStart", ->

					$("body").addClass "draggingBox"
				draggie.on "dragEnd", (draggie, event, pointer) ->
					if (event.y < 160) and ($(window).width()-event.x) < 160
						#in trash
						articleID = draggie.element.id
						Articles.remove _id: articleID
					$("body").removeClass "draggingBox"
					unless draggie.dragPoint.x == draggie.dragPoint.y == 0
						# was a drag, prevent click
						$( event.toElement ).one 'click', (e) -> e.stopImmediatePropagation()
				
				$board.packery 'bindDraggabillyEvents', draggie 

	

		

	layout = _.debounce ->
		$board.packery "reloadItems"
		$board.packery()
		
	, 100
		

	console.log "set"
	@autorun =>
		console.log "relayot"
		Meteor.setTimeout layout, 200
		Articles.find({},  {sort: {position: 1}, fields:{position:1}}).fetch()
		Articles.find().count()

	


