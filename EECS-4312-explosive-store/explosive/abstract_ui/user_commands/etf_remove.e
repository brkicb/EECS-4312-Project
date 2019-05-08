note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REMOVE
inherit
	ETF_REMOVE_INTERFACE
		redefine remove end
create
	make
feature -- command
	remove(id: STRING)
		require else
			remove_precond(id)
    	do
			-- perform some update on the model state
			model.remove (id)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
