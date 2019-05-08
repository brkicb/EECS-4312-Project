note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LARGE_EXPLOSIVES
inherit
	ETF_LARGE_EXPLOSIVES_INTERFACE
		redefine large_explosives end
create
	make
feature -- command
	large_explosives(xlength: INTEGER_64 ; ylength: INTEGER_64)
		require else
			large_explosives_precond(xlength, ylength)
    	do
			-- perform some update on the model state
			model.large_explosives (xlength, ylength)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
