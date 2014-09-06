
getBoard = ($article) ->
	$article.closest Constants.BOARD_SELECTOR

expand = ($article) ->
	unless $article.hasClass "expanded"
		$board = getBoard $article
		$board.find("article").not($article).removeClass "expanded"

		$article.addClass "expanded"
		$board.packery "fit", $article.get 0

shrink = ($article) ->
	
	if $article.hasClass("expanded")
			
		$board = getBoard $article
		$article.removeClass "expanded"
		$board.packery()

toggleExpand = ($article) ->
	if $article.hasClass "expanded"
		shrink $article
	else
		expand $article

addBox = (size, position)->
	Articles.insert 
		size: size
		position: position
Template.article_box.events
	
	"dropped article": (event, template) ->
		size =  event.originalEvent?.dataTransfer?.getData 'size'
		position = template.data.position
		addBox size, position-1
	"click article:not(.edit)": (event, template) ->
		$article = template.$ "article"
		Meteor.setTimeout ->
			unless  $article.hasClass "edit"
				toggleExpand $article 
		, 100

	"dblclick article:not(.edit)": (event, template) ->
		
		
		$article = template.$ "article"

		$staticContent = $article.find ".content.static"
		$board = getBoard $article
		$article.addClass "edit"
		
		expand $article
		

		$editor = $staticContent.clone()
		$editor.addClass "editor"
		$editor.removeClass "static"
		$editor.attr "contenteditable", true
		$staticContent.hide()
	
		$editor.insertAfter $staticContent
		editor = CKEDITOR.inline $editor.get 0
		Meteor.setTimeout ->
			editor.focus()
		, 100
		editor.on 'change', _.debounce (e) => 
			$board.packery()
			Articles.update {_id: template.data._id}, $set: content:  editor.getData()
		, 100
		editor.on 'blur', (e) =>
			
			editor.destroy()
			$editor.remove()
			$staticContent.show()
			$article.removeClass "edit"
			

		return false
	
		


Template.article_box.editMode = ->
	
	@_id == Session.get("editArticle")



Template.article_box.sizeClasses = ->
	Constants.getSizeClasses @size
	