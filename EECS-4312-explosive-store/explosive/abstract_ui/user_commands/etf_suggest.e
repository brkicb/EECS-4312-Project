note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SUGGEST
inherit
	ETF_SUGGEST_INTERFACE
		redefine suggest end
create
	make
feature -- command
	suggest(explosive: TUPLE[xlength: INTEGER_64; ylength: INTEGER_64])
		require else
			suggest_precond(explosive)
    	do
			-- perform some update on the model state
			model.suggest (explosive)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
