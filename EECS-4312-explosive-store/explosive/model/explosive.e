note
	description: "Summary description for {EXPLOSIVE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLOSIVE

create
	make

feature -- attributes
	id: STRING
	x_position: INTEGER_64
	y_position: INTEGER_64
	xbound: INTEGER_64
	ybound: INTEGER_64

feature {NONE}
	make(my_id: STRING ; my_x_position: INTEGER_64 ; my_y_position: INTEGER_64 ; my_xbound: INTEGER_64 ; my_ybound: INTEGER_64)
		do
			id := my_id
			x_position := my_x_position
			y_position := my_y_position
			xbound := my_xbound
			ybound := my_ybound
		end

end
