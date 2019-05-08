------------------------------ MODULE explosive ------------------------------
EXTENDS Integers, Sequences, TLC

CONSTANTS 
    ID,        (*set of every posible ID that can exist*)
    N          (*the largest a store can be*)
    
VARIABLES 
    ids          (*set of all ids present in store*),
    positions,   (*set of all positions present in store*)
    dimensions,  (*set of all dimensions present in store*)
    explosives,  (*tuple of all position | dimension pairs present in store*)
    xbound,
    ybound
    
vars == <<ids,positions,dimensions,explosives,xbound,ybound>>
    
ASSUME N > 0 

UNIT == 0..N

UNIT_RECORD == [x : UNIT, y : UNIT]

(*set of all positions an EXPLOSIVE can be placed [0,0] to [N-1, N-1]*)
POSITION == {r \in UNIT_RECORD : r.x < N /\ r.y < N}

(*set of all dimensions an explosive can envolope [1,1] to [N, N]*)
DIMENSION == {r \in UNIT_RECORD : r.x > 0 /\ r.y > 0}


(*Invariants*)
TypeOk == 
    /\ ids \subseteq ID
    /\ positions \subseteq POSITION
    /\ dimensions \subseteq DIMENSION
    /\ explosives \in [ids -> [pos: POSITION, dim: DIMENSION]]

safely_stored == 
    /\ ids \subseteq ID

idOk == 
    /\ ids \subseteq ID


(*Initialization*)

Init ==
    /\ ids = {}
    /\ xbound = 0
    /\ ybound = 0
    /\ explosives = <<>>
    /\ positions = {}
    /\ dimensions = {}

(*Actions*)

new_store(x, y) ==
    /\ x > 0 
    /\ x <= N
    /\ y > 0
    /\ y <= N
    /\ ids = {}
    \* ------ guards ------
    /\ ids' = ids
    /\ explosives' = explosives
    /\ positions' = positions
    /\ dimensions' = dimensions
    /\ xbound' = x
    /\ ybound' = y

put(id, d, p) ==
    /\ id \notin ID
    /\ p.x + d.x =< xbound
    /\ p.y + d.y =< ybound
    /\ ids # {}
    \* ------ guards ------
    /\ ids' = ids \union {id}
    /\ \A e \in explosives:
        \neg (
            (p = e.pos)
            \/ ((d.x + p.x) \in (e.pos.x .. e.dim.x)) \* at same row,    a conflict width by width
            \/ ((d.y + p.y) \in (e.pos.y .. e.dim.y)) \* at some row,    a conflict width by height
        ) 

remove(id) == 
    /\ id \in ID
    /\ ids # {}
    \* ------ guards ------
    /\ ids' = ids \ {id}

suggest(x,y) == 
    /\ x > 0
    /\ x <= xbound
    /\ y > 0
    /\ y <= ybound
    /\ ids # {}
    \* ------ guards ------

large_explosive(x,y) == 
    /\ x > 0
    /\ x <= xbound
    /\ y > 0
    /\ y <= ybound
    /\ ids # {}
    \* ------ guards ------  
    
Next == \/ \E x,y \in N: new_store(x,y)
        \/ \E id \in ids, d \in dimensions, p \in positions: put(id,d,p)
        \/ \E id \in ids: remove(id)
        \/ \E x \in xbound, y \in ybound: suggest(x,y)
        \/ \E x \in xbound, y \in ybound: large_explosive(x,y)
        
Spec == /\ Init
        /\ [][Next]_vars
    
=============================================================================
