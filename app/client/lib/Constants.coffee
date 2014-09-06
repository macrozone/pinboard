window.Constants = 
	BOARD_SELECTOR: ".board"

	getSizeClasses: (size) ->
		switch size
			when 'l' then 'col-xs-12 col-sm-12 col-md-6 col-lg-6'
			when 's' then 'col-xs-6 col-sm-3 col-md-2 col-lg-2'
			else 'col-xs-6 col-sm-6 col-md-4 col-lg-4'
