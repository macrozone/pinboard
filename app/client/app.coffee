Router.configure layoutTemplate: 'layout'

fuckIn = ->
		$("body").addClass "boom"
		Meteor.setTimeout ->
			$("body").removeClass "boom"
			$("body").addClass "fuckoff"
			Meteor.setTimeout fuckOut, 5000
		, 300

fuckOut = ->
	$("body").removeClass "fuckoff"
	$("body").addClass "boom"

	Meteor.setTimeout ->
		$("body").removeClass "boom"
		if Session.get "sandromode"
			Meteor.setTimeout fuckIn, 5000
	, 300

Template.header.events
	"click .btn-toggle-fuck": ->
		Session.set "sandromode", !Session.get "sandromode"
		if Session.get "sandromode"
			fuckIn()

Template.header.sandromode = -> Session.get "sandromode"