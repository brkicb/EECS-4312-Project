note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature -- model attributes
	s : STRING
	i : INTEGER
	store : ARRAY2[STRING]
	suggested_positions : ARRAY2[STRING]
	explosives : LINKED_LIST[EXPLOSIVE]
	large_explosives_list : LINKED_LIST[STRING]
	sorted_explosives : LINKED_LIST[EXPLOSIVE]
	error : STRING
	is_error : BOOLEAN
	is_store_present : BOOLEAN
	is_suggest: BOOLEAN
	is_large_explosive: BOOLEAN

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			create store.make_filled ("__" , 1, 1)
			create error.make_empty
			create explosives.make
			create suggested_positions.make_filled ("_____", 1, 1)
			create large_explosives_list.make
			create sorted_explosives.make
			is_error := false
			is_store_present := false
			is_suggest := false
			is_large_explosive := false
			i := 0
		end

feature

	--NEW_STORE
	new_store(xbound: INTEGER_64 ; ybound: INTEGER_64)
		do
			if not is_store_empty then
				is_error := true
				error := "e11: Current store not empty"
			elseif xbound ~ 0 or ybound ~ 0 then
				is_error := true
				error := "e01: Store must have bounds of at least [1,1]"
			else
				create store.make_filled ("__", ybound.as_integer_32, xbound.as_integer_32)
				create suggested_positions.make_filled ("_____", ybound.as_integer_32, xbound.as_integer_32)
				create explosives.make
				is_store_present := true
			end
		end

	--PUT
	put(id: STRING ; explosive: TUPLE[xlength: INTEGER_64 ; ylength: INTEGER_64] ; position: TUPLE[x: INTEGER_64 ; y: INTEGER_64])
		local
			row : INTEGER_64
			col : INTEGER_64
			my_explosive: EXPLOSIVE
		do
			if not is_store_present then
				is_error := true
				error := "e02: Store must exist"
			else
				-- Handle error e3
				if is_id_present(id) ~ true then
					is_error := true
					error := "e03: ID already exists"
				-- Handle error e4
				elseif id.count /~ 2 then
					is_error := true
					error := "e04: ID must be two characters in length"
				elseif not id.at (1).is_alpha then
					is_error := true
					error := "e05: First character of ID must be a letter"
				elseif not id.at (2).is_digit then
					is_error := true
					error := "e06: Second character of ID must be a number"
				-- Handle error e8
				elseif explosive.xlength ~ 0 or explosive.ylength ~ 0 then
					is_error := true
					error := "e07: Explosive must be at least [1,1]"
				elseif position.y >= store.height or position.x >= store.width or position.x + explosive.xlength > store.width or position.y + explosive.ylength > store.height then
					is_error := true
					error := "e08: Explosive must be placed within store bounds"
				-- Handle error e9
				elseif is_overlap(explosive.xlength,explosive.ylength,position.x,position.y) ~ true then
					is_error := true
					error := "e09: Explosive will overlap with another explosive"
				else
					create my_explosive.make (id, position.x, position.y, explosive.xlength, explosive.ylength)
					explosives.extend (my_explosive)
					sort_explosives
					from
						row := store.height - position.y
					until
						row < store.height - position.y - explosive.ylength + 1
					loop
						from
							col := position.x + 1
						until
							col > position.x + explosive.xlength
						loop
							store.put (id, row.as_integer_32, col.as_integer_32)
							col := col + 1
						end
						row := row - 1
					end
				end
			end
		end

	--REMOVE
	remove(id: STRING)
		local
			row: INTEGER_32
			col: INTEGER_32
			flag: BOOLEAN
			e: EXPLOSIVE
		do
			if not is_store_present then
				is_error := true
				error := "e02: Store must exist"
			else
				-- Handle error e10
				if not is_id_present(id) then
					is_error := true
					error := "e10: ID does not exist"
				else
					from
						row := 1
					until
						row > store.height
					loop
						from
							col := 1
						until
							col > store.width
						loop
							if store.item (row, col) ~ id then
								store.put ("__", row, col)
							end
							col := col + 1
						end
						row := row + 1
					end
					flag := false
					from
						explosives.start
					until
						explosives.after
					loop
						if explosives.islast then
							flag := true
						end
						if explosives.count ~ 1 then
							create explosives.make
						elseif not flag and explosives.item.id ~ id then
							explosives.remove
						elseif flag and explosives.item.id ~ id then
							explosives.back
							e := explosives.item
							explosives.remove
							explosives.extend (e)
							explosives.remove
						end
						explosives.forth
					end
				end
				sort_explosives
			end
		end

	--SUGGEST
	suggest(explosive: TUPLE[xlength: INTEGER_64 ; ylength: INTEGER_64])
		local
			x_pos: INTEGER_64
			y_pos: INTEGER_64
			w: INTEGER_32
			h: INTEGER_32
		do
			w := store.width
			h := store.height
			if not is_store_present then
				is_error := true
				error := "e02: Store must exist"
			else
				create suggested_positions.make_filled ("_____", h, w)
				is_suggest := true
				if explosive.xlength ~ 0 or explosive.ylength ~ 0 then
					is_error := true
					error := "e07: Explosive must be at least [1,1]"
				else
					from
						x_pos := 0
					until
						x_pos + 1 > w
					loop
						from
							y_pos := 0
						until
							y_pos + 1 > h
						loop
							if x_pos + explosive.xlength > w or y_pos + explosive.ylength > h or is_overlap(explosive.xlength, explosive.ylength, x_pos, y_pos) ~ true then
								if store.width > 10 and store.height > 10 then
									if y_pos >= 10 and x_pos >= 10 then
										suggested_positions.put ("_______", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
									elseif x_pos >= 10 and y_pos < 10 then
										suggested_positions.put ("_______", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
									elseif y_pos >= 10 and x_pos < 10 then
										suggested_positions.put ("______", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
									else
										suggested_positions.put ("______", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
									end
								elseif store.width > 10 then
									if x_pos >= 10 then
										suggested_positions.put ("______", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
									else
										suggested_positions.put ("_____", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
									end
								elseif store.height > 10 then
									suggested_positions.put ("______", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
								else
									suggested_positions.put ("_____", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
								end
							else
								if store.width > 10 and store.height > 10 then
									if y_pos >= 10 and x_pos >= 10 then
										suggested_positions.put ("[" + x_pos.out + "," + y_pos.out + "]", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
									elseif y_pos >= 10 then
										suggested_positions.put ("[" + x_pos.out + "," + y_pos.out + "]", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
									elseif x_pos >= 10 then
										suggested_positions.put ("[" + x_pos.out + ", " + y_pos.out + "]", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
									else
										suggested_positions.put ("[" + x_pos.out + ", " + y_pos.out + "]", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
									end
								elseif store.height > 10 then
									if y_pos >= 10 then
										suggested_positions.put ("[" + x_pos.out + "," + y_pos.out + "]", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
									else
										suggested_positions.put ("[" + x_pos.out + ", " + y_pos.out + "]", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
									end
								else
									suggested_positions.put ("[" + x_pos.out + "," + y_pos.out + "]", h - y_pos.as_integer_32, x_pos.as_integer_32 + 1)
								end
							end
							y_pos := y_pos + 1
						end
						x_pos := x_pos + 1
					end
				end
			end
		end

	--LARGE_EXPLOSIVES
	large_explosives(xlength: INTEGER_64 ; ylength: INTEGER_64)
		do
			if not is_store_present then
				is_error := true
				error := "e02: Store must exist"
			else
				if xlength ~ 0 or ylength ~ 0 then
					is_error := true
					error := "e07: Explosive must be at least [1,1]"
				else
					is_large_explosive := true
					create large_explosives_list.make
					from
						explosives.start
					until
						explosives.after
					loop
						if explosives.item.xbound >= xlength and explosives.item.ybound >= ylength then
							large_explosives_list.extend (explosives.item.id + "->[" + explosives.item.xbound.out + "," + explosives.item.ybound.out + "]")
						end
						explosives.forth
					end
					if large_explosives_list.is_empty then
						is_error := true
						error := "%N  There are no explosives of size [" + xlength.out + "," + ylength.out + "]"
					end
					sort_explosives
				end
			end
		end

feature -- utilities
	print_store: STRING
		local
			x : INTEGER_32
			y : INTEGER_32
		do
			create Result.make_from_string ("  ")
			if is_store_present then
				from
					x := 1
				until
					-- rows
					x > store.height
				loop
					from
						-- columns
						y := 1
					until
						y > store.width
					loop
						Result.append(store.item (x, y) + " ")
						y := y + 1
					end
					x := x + 1
					if x <= store.height then
						Result.append("%N  ")
					end
				end
			end
		end

	print_suggested_positions: STRING
		local
			x : INTEGER_32
			y : INTEGER_32
		do
			create Result.make_from_string ("  ")
			if is_store_present then
				from
					x := 1
				until
					-- rows
					x > suggested_positions.height
				loop
					from
						-- columns
						y := 1
					until
						y > suggested_positions.width
					loop
						Result.append(suggested_positions.item (x, y))
						y := y + 1
					end
					x := x + 1
					if x <= suggested_positions.height then
						Result.append("%N  ")
					end
				end
			end
		end

	print_large_explosives: STRING
		do

			create Result.make_from_string ("  ")
			from
				large_explosives_list.start
			until
				large_explosives_list.after
			loop
				if not large_explosives_list.islast then
					Result.append (large_explosives_list.item.out + ", ")
				else
					Result.append (large_explosives_list.item.out)
				end
				large_explosives_list.forth
			end
		end

	is_id_present(check_id: STRING): BOOLEAN
		local
			row: INTEGER_32
			col: INTEGER_32
		do
			Result := false
			from
				row := 1
			until
				row > store.height
			loop
				from
					col := 1
				until
					col > store.width
				loop
					if store.item (row, col) ~ check_id then
						Result := true
					end
					col := col + 1
				end
				row := row + 1
			end
		end

	is_overlap(check_xlength: INTEGER_64 ; check_ylength: INTEGER_64 ; check_x: INTEGER_64 ; check_y: INTEGER_64): BOOLEAN
		local
			row: INTEGER_64
			col: INTEGER_64
		do
			Result := false
			from
				row := store.height - check_y
			until
				row < store.height - check_y - check_ylength + 1
			loop
				from
					col := check_x + 1
				until
					col > check_x + check_xlength
				loop
					if store.item (row.as_integer_32, col.as_integer_32) /~ "__" then
						Result := true
					end
					col := col + 1
				end
				row := row - 1
			end
		end

	is_store_empty: BOOLEAN
		local
			x : INTEGER_32
			y : INTEGER_32
		do
			Result := true
			from
				x := 1
			until
				-- rows
				x > store.height
			loop
				from
					-- columns
					y := 1
				until
					y > store.width
				loop
					if store.item (x,y) /~ "__" then
						Result := false
					end
					y := y + 1
				end
				x := x + 1
			end
		end

	sort_explosives
		local
			index_i : INTEGER
			index_j : INTEGER
			-- SORTED_TWO_WAY_LIST has a sort command that can easily sort the phase ids
			explosives_id_list : SORTED_TWO_WAY_LIST[STRING]
		do
			create sorted_explosives.make
			create explosives_id_list.make
			from
				index_i := explosives.lower
			until
				index_i > explosives.count
			loop
				explosives_id_list.extend (explosives[index_i].id)
				index_i := index_i + 1
			end
			explosives_id_list.sort
			from
				index_i := 1
			until
				index_i > explosives_id_list.count
			loop
				from
					index_j := explosives.lower
				until
					index_j > explosives.count
				loop
					if explosives_id_list[index_i] ~ explosives[index_j].id then
						sorted_explosives.extend (explosives[index_j])
					end
					index_j := index_j + 1
				end
				index_i := index_i + 1
			end
		end

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- queries
	out : STRING
		do
			if i ~ 0 then
				create Result.make_from_string ("  ")
				Result.append ("System State: ")
				Result.append ("(")
				Result.append (i.out)
				Result.append (") Create a new store")
			elseif is_error then
				create Result.make_from_string ("  ")
				Result.append ("System State: ")
				Result.append ("(")
				Result.append (i.out)
				Result.append (") ")
				Result.append (error)
				is_error := false
			elseif is_suggest then
				is_suggest := false
				create Result.make_from_string ("  ")
				Result.append ("System State: ")
				Result.append ("(")
				Result.append (i.out)
				Result.append (") %N")
				Result.append(print_suggested_positions)
			elseif is_large_explosive then
				is_large_explosive := false
				create Result.make_from_string ("  ")
				Result.append ("System State: ")
				Result.append ("(")
				Result.append (i.out)
				Result.append (") %N")
				Result.append(print_large_explosives)
			else
				create Result.make_from_string ("  ")
				Result.append ("System State: ")
				Result.append ("(")
				Result.append (i.out)
				Result.append (") %N")
				Result.append(print_store)
			end
		end

end
