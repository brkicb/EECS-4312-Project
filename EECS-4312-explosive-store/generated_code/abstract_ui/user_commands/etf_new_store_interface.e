note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_NEW_STORE_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent new_store(? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as xbound and then attached {INTEGER_64} etf_cmd_args[2] as ybound
			then
				out := "new_store(" + etf_event_argument_out("new_store", "xbound", xbound) + "," + etf_event_argument_out("new_store", "ybound", ybound) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	new_store_precond(xbound: INTEGER_64 ; ybound: INTEGER_64): BOOLEAN
		do  
			Result := 
				         is_unit(xbound)
					-- (0 <= xbound) and then (xbound <= 100)
				and then is_unit(ybound)
					-- (0 <= ybound) and then (ybound <= 100)
		ensure then  
			Result = 
				         is_unit(xbound)
					-- (0 <= xbound) and then (xbound <= 100)
				and then is_unit(ybound)
					-- (0 <= ybound) and then (ybound <= 100)
		end 
feature -- command 
	new_store(xbound: INTEGER_64 ; ybound: INTEGER_64)
		require 
			new_store_precond(xbound, ybound)
    	deferred
    	end
end
