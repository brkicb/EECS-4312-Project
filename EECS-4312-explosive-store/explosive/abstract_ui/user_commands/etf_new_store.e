note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_STORE
inherit
	ETF_NEW_STORE_INTERFACE
		redefine new_store end
create
	make
feature -- command
	new_store(xbound: INTEGER_64 ; ybound: INTEGER_64)
		require else
			new_store_precond(xbound, ybound)
    	do
			-- perform some update on the model state
			model.new_store (xbound, ybound)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
