note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PUT
inherit
	ETF_PUT_INTERFACE
		redefine put end
create
	make
feature -- command
	put(id: STRING ; explosive: TUPLE[xlength: INTEGER_64; ylength: INTEGER_64] ; position: TUPLE[x: INTEGER_64; y: INTEGER_64])
		require else
			put_precond(id, explosive, position)
    	do
			-- perform some update on the model state
			model.put (id, explosive, position)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
