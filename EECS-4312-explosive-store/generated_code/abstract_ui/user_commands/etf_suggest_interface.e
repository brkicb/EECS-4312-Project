note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_SUGGEST_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent suggest(?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {TUPLE[xlength: INTEGER_64; ylength: INTEGER_64]} etf_cmd_args[1] as explosive
			then
				out := "suggest(" + etf_event_argument_out("suggest", "explosive", explosive) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	suggest_precond(explosive: TUPLE[xlength: INTEGER_64; ylength: INTEGER_64]): BOOLEAN
		do  
			Result := 
				         is_explosive(explosive)
					-- (0 <= explosive.xlength) and then (explosive.xlength <= 100)
					-- and then (0 <= explosive.ylength) and then (explosive.ylength <= 100)
		ensure then  
			Result = 
				         is_explosive(explosive)
					-- (0 <= explosive.xlength) and then (explosive.xlength <= 100)
					-- and then (0 <= explosive.ylength) and then (explosive.ylength <= 100)
		end 
feature -- command 
	suggest(explosive: TUPLE[xlength: INTEGER_64; ylength: INTEGER_64])
		require 
			suggest_precond(explosive)
    	deferred
    	end
end
