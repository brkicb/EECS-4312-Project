note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_PUT_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent put(? , ? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {STRING} etf_cmd_args[1] as id and then attached {TUPLE[xlength: INTEGER_64; ylength: INTEGER_64]} etf_cmd_args[2] as explosive and then attached {TUPLE[x: INTEGER_64; y: INTEGER_64]} etf_cmd_args[3] as position
			then
				out := "put(" + etf_event_argument_out("put", "id", id) + "," + etf_event_argument_out("put", "explosive", explosive) + "," + etf_event_argument_out("put", "position", position) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	put_precond(id: STRING ; explosive: TUPLE[xlength: INTEGER_64; ylength: INTEGER_64] ; position: TUPLE[x: INTEGER_64; y: INTEGER_64]): BOOLEAN
		do  
			Result := 
				         comment ("ID = STRING")
				and then 
				is_explosive(explosive)
					-- (0 <= explosive.xlength) and then (explosive.xlength <= 100)
					-- and then (0 <= explosive.ylength) and then (explosive.ylength <= 100)
				and then is_position(position)
					-- (0 <= position.x) and then (position.x <= 100)
					-- and then (0 <= position.y) and then (position.y <= 100)
		ensure then  
			Result = 
				         comment ("ID = STRING")
				and then 
				is_explosive(explosive)
					-- (0 <= explosive.xlength) and then (explosive.xlength <= 100)
					-- and then (0 <= explosive.ylength) and then (explosive.ylength <= 100)
				and then is_position(position)
					-- (0 <= position.x) and then (position.x <= 100)
					-- and then (0 <= position.y) and then (position.y <= 100)
		end 
feature -- command 
	put(id: STRING ; explosive: TUPLE[xlength: INTEGER_64; ylength: INTEGER_64] ; position: TUPLE[x: INTEGER_64; y: INTEGER_64])
		require 
			put_precond(id, explosive, position)
    	deferred
    	end
end
