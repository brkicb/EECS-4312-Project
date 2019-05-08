note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_LARGE_EXPLOSIVES_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent large_explosives(? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as xlength and then attached {INTEGER_64} etf_cmd_args[2] as ylength
			then
				out := "large_explosives(" + etf_event_argument_out("large_explosives", "xlength", xlength) + "," + etf_event_argument_out("large_explosives", "ylength", ylength) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	large_explosives_precond(xlength: INTEGER_64 ; ylength: INTEGER_64): BOOLEAN
		do  
			Result := 
				         is_unit(xlength)
					-- (0 <= xlength) and then (xlength <= 100)
				and then is_unit(ylength)
					-- (0 <= ylength) and then (ylength <= 100)
		ensure then  
			Result = 
				         is_unit(xlength)
					-- (0 <= xlength) and then (xlength <= 100)
				and then is_unit(ylength)
					-- (0 <= ylength) and then (ylength <= 100)
		end 
feature -- command 
	large_explosives(xlength: INTEGER_64 ; ylength: INTEGER_64)
		require 
			large_explosives_precond(xlength, ylength)
    	deferred
    	end
end
