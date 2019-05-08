class
 	 ETF_TYPE_CONSTRAINTS

feature -- type queries 

	is_unit(etf_v: INTEGER_64): BOOLEAN 
		require
			comment("etf_v: UNIT = 0 .. 100")
		do
			 Result := 
				(0 <= etf_v) and then (etf_v <= 100)
		ensure
			 Result = 
				(0 <= etf_v) and then (etf_v <= 100)
		end

	is_position(etf_v: TUPLE[x: INTEGER_64; y: INTEGER_64]): BOOLEAN 
		require
			comment("etf_v: POSITION = TUPLE[x: UNIT = 0 .. 100; y: UNIT = 0 .. 100]")
		do
			 Result := 
				         is_unit(etf_v.x)
				and then is_unit(etf_v.y)
		ensure
			 Result = 
				         is_unit(etf_v.x)
				and then is_unit(etf_v.y)
		end

	is_explosive(etf_v: TUPLE[xlength: INTEGER_64; ylength: INTEGER_64]): BOOLEAN 
		require
			comment("etf_v: EXPLOSIVE = TUPLE[xlength: UNIT = 0 .. 100; ylength: UNIT = 0 .. 100]")
		do
			 Result := 
				         is_unit(etf_v.xlength)
				and then is_unit(etf_v.ylength)
		ensure
			 Result = 
				         is_unit(etf_v.xlength)
				and then is_unit(etf_v.ylength)
		end
feature -- list of enumeratd constants
	enum_items : HASH_TABLE[INTEGER, STRING]
		do
			create Result.make (10)
		end

	enum_items_inverse : HASH_TABLE[STRING, INTEGER_64]
		do
			create Result.make (10)
		end
feature -- query on declarations of event parameters
	evt_param_types_table : HASH_TABLE[HASH_TABLE[ETF_PARAM_TYPE, STRING], STRING]
		local
			new_store_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			put_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			remove_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			suggest_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			large_explosives_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
		do
			create Result.make (10)
			Result.compare_objects
			create new_store_param_types.make (10)
			new_store_param_types.compare_objects
			new_store_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)), "xbound")
			new_store_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)), "ybound")
			Result.extend (new_store_param_types, "new_store")
			create put_param_types.make (10)
			put_param_types.compare_objects
			put_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID", create {ETF_STR_PARAM}), "id")
			put_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("EXPLOSIVE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("xlength", create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100))), create {ETF_PARAM_DECL}.make("ylength", create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)))>>)), "explosive")
			put_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("POSITION", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("x", create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100))), create {ETF_PARAM_DECL}.make("y", create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)))>>)), "position")
			Result.extend (put_param_types, "put")
			create remove_param_types.make (10)
			remove_param_types.compare_objects
			remove_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID", create {ETF_STR_PARAM}), "id")
			Result.extend (remove_param_types, "remove")
			create suggest_param_types.make (10)
			suggest_param_types.compare_objects
			suggest_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("EXPLOSIVE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("xlength", create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100))), create {ETF_PARAM_DECL}.make("ylength", create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)))>>)), "explosive")
			Result.extend (suggest_param_types, "suggest")
			create large_explosives_param_types.make (10)
			large_explosives_param_types.compare_objects
			large_explosives_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)), "xlength")
			large_explosives_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)), "ylength")
			Result.extend (large_explosives_param_types, "large_explosives")
		end
feature -- query on declarations of event parameters
	evt_param_types_list : HASH_TABLE[LINKED_LIST[ETF_PARAM_TYPE], STRING]
		local
			new_store_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			put_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			remove_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			suggest_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			large_explosives_param_types: LINKED_LIST[ETF_PARAM_TYPE]
		do
			create Result.make (10)
			Result.compare_objects
			create new_store_param_types.make
			new_store_param_types.compare_objects
			new_store_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)))
			new_store_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)))
			Result.extend (new_store_param_types, "new_store")
			create put_param_types.make
			put_param_types.compare_objects
			put_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID", create {ETF_STR_PARAM}))
			put_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("EXPLOSIVE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("xlength", create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100))), create {ETF_PARAM_DECL}.make("ylength", create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)))>>)))
			put_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("POSITION", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("x", create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100))), create {ETF_PARAM_DECL}.make("y", create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)))>>)))
			Result.extend (put_param_types, "put")
			create remove_param_types.make
			remove_param_types.compare_objects
			remove_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID", create {ETF_STR_PARAM}))
			Result.extend (remove_param_types, "remove")
			create suggest_param_types.make
			suggest_param_types.compare_objects
			suggest_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("EXPLOSIVE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("xlength", create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100))), create {ETF_PARAM_DECL}.make("ylength", create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)))>>)))
			Result.extend (suggest_param_types, "suggest")
			create large_explosives_param_types.make
			large_explosives_param_types.compare_objects
			large_explosives_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)))
			large_explosives_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UNIT", create {ETF_INTERVAL_PARAM}.make(0, 100)))
			Result.extend (large_explosives_param_types, "large_explosives")
		end
feature -- comments for contracts
	comment(etf_s: STRING): BOOLEAN
		do
			Result := TRUE
		end
end