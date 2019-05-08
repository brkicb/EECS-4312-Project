note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_REMOVE_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent remove(?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {STRING} etf_cmd_args[1] as id
			then
				out := "remove(" + etf_event_argument_out("remove", "id", id) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	remove_precond(id: STRING): BOOLEAN
		do  
			Result := 
				comment ("ID = STRING")
		ensure then  
			Result = 
				comment ("ID = STRING")
		end 
feature -- command 
	remove(id: STRING)
		require 
			remove_precond(id)
    	deferred
    	end
end
