(define (domain building)

(:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :equality :disjunctive-preconditions)

(:types 
    lift - object 
    slowlift fastlift - lift
    person - object
    num - object            ; "number" seems to be "reseved", at least the IDE is showing some error
)

(:predicates
    (in ?p - person ?l - lift)              ; The person P is inside lift L
    (person-at ?p - person ?n - num)        ; The person P is at level N
    (lift-at ?l - lift ?n - num)     ; The lift L is at level N
    (can-stop-at ?l - lift ?n - num)           ; The lift L can stop at level N (I'd like to replace it by checking if a number is pair assigning (is-pair n0) and check recursively if something is pair or after 2 next back is pair, but not sure how to do it now)
    (next ?n1 ?n2 - num)                    ; N1 is the previous numbner of N1
    (people-in-lift ?l - lift ?np - num)                 ; Lift L has NP people inside
    (desinfectado ?l - lift)    
)


(:functions
    (time-per-floor-fastlift)            ; Units of time required to move 1 floor up or down on a fast lift
    (time-per-floor-slowlift)         ; Units of time required to move 1 floor up or down on a slow lift
    (t-embarque)
)

; MOVE-up action for slow lifts (Divided in Move-up and move-down after asking at lab time)
; Started with move-up and move-down as requested, but simplified in only 1 action
(:durative-action move-up
    :parameters (?l - slowlift ?l1 ?l2 - num)
    :duration (= ?duration (time-per-floor-slowlift)) ; Get the duration based on the lift used
    :condition (and 
        (at start (and
            (lift-at ?l ?l1)        ; Lift is at starting level
            (next ?l1 ?l2)          ; Lift can only move "sequentially", we cannot go from floor 1 to floor 3. It doesn't means that we can stop at all levels
        ))
    )
    :effect (and 
        (at start (and
            (not (lift-at ?l ?l1))   ; Lift is no longer at start
        ))
        (at end (and
            (lift-at ?l ?l2)         ; Lift is at destination level
        ))
    )
)

; MOVE-down action for slow lifts
; Started with move-up and move-down as requested, but simplified in only 1 action
(:durative-action move-down
    :parameters (?l - slowlift ?l1 ?l2 - num)
    :duration (= ?duration (time-per-floor-slowlift)) ; Get the duration based on the lift used
    :condition (and 
        (at start (and
            (lift-at ?l ?l1)        ; Lift is at starting level
            (next ?l2 ?l1)          ; Lift can only move "sequentially", we cannot go from floor 1 to floor 3. It doesn't means that we can stop at all levels
        ))
    )
    :effect (and 
        (at start (and
            (not (lift-at ?l ?l1))   ; Lift is no longer at start
        ))
        (at end (and
            (lift-at ?l ?l2)         ; Lift is at destination level
        ))
    )
)

; MOVE-up action for fast lifts (Divided in Move-up and move-down after asking at lab time)
; Started with move-up and move-down as requested, but simplified in only 1 action
; It seems to work with 2 actions named in the same way but with different parameters type, but as the IDE shows a warning I renamed them
(:durative-action move-up-fast
    :parameters (?l - fastlift ?l1 ?l2 - num)
    :duration (= ?duration (time-per-floor-fastlift)) ; Get the duration based on the lift used
    :condition (and 
        (at start (and
            (lift-at ?l ?l1)        ; Lift is at starting level
            (next ?l1 ?l2)          ; Lift can only move "sequentially", we cannot go from floor 1 to floor 3. It doesn't means that we can stop at all levels
        ))
    )
    :effect (and 
        (at start (and
            (not (lift-at ?l ?l1))   ; Lift is no longer at start
        ))
        (at end (and
            (lift-at ?l ?l2)         ; Lift is at destination level
        ))
    )
)

; MOVE-down action for fast lifts (Divided in Move-up and move-down after asking at lab time)
; Started with move-up and move-down as requested, but simplified in only 1 action
(:durative-action move-down-fast
    :parameters (?l - fastlift ?l1 ?l2 - num)
    :duration (= ?duration (time-per-floor-fastlift)) ; Get the duration based on the lift used
    :condition (and 
        (at start (and
            (lift-at ?l ?l1)        ; Lift is at starting level
            (next ?l2 ?l1)          ; Lift can only move "sequentially", we cannot go from floor 1 to floor 3. It doesn't means that we can stop at all levels
        ))
    )
    :effect (and 
        (at start (and
            (not (lift-at ?l ?l1))   ; Lift is no longer at start
        ))
        (at end (and
            (lift-at ?l ?l2)         ; Lift is at destination level
        ))
    )
)

; BOARD action
; Board the person P at lift L
; np1 = Current number of people in the lift
; np2 = The new amount of people once boarded
; lvl = Floor in which the person and lift must be
(:durative-action board
    :parameters (?p - person ?l - lift ?np1 ?np2 ?lvl - num)
    :duration (= ?duration (t-embarque))
    :condition (and 
        (at start (and 
            (person-at ?p ?lvl)             ; The person must be at the given lvl
            (lift-at ?l ?lvl)               ; The lift must be at the given lvl
            (next ?np1 ?np2)                ; The amount of people after must be the following number of before
            (people-in-lift ?l ?np1)        ; The number of people in the lift before boarding must be correct
            (can-stop-at ?l ?lvl)           ; We can only board people if the lift can stop in the initial floor
            (desinfectado ?l)
        ))
    )
    :effect (and 
        (at end (and 
            (in ?p ?l)                      ; Person is in the lift given
            (people-in-lift ?l ?np2)        ; Now the number of people is NP2
            (not (people-in-lift ?l ?np1))  ; The number of people is no longer NP1
            (not (person-at ?p ?lvl))       ; That person is no longer at the floor (is now inside the lift)
        ))
    )
)

; LEAVE action
; Leave the person P from lift L
; np1 = Current number of people in the lift
; np2 = The new amount of people once the person left the lift
; lvl = Floor in which the person and lift must be
(:durative-action leave
    :parameters (?p - person ?l - lift ?np1 ?np2 ?lvl - num)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (in ?p ?l)                      ; The person must be inside the given lift
            (lift-at ?l ?lvl)               ; The lift must be at the given lvl
            (next ?np2 ?np1)                ; The amount of people after must be the previous number of before
            (people-in-lift ?l ?np1)        ; The number of people in the lift before boarding must be correct
            (can-stop-at ?l ?lvl)           ; We can only leave people if the lift can stop in the given floor
        ))
    )
    :effect (and 
        (at end (and 
            (not (in ?p ?l))                ; Person is no longer in the lift
            (person-at ?p ?lvl)             ; Person is now at the floor ?lvl
            (people-in-lift ?l ?np2)        ; Now the number of people is NP2
            (not (people-in-lift ?l ?np1))  ; The number of people is no longer NP1
        ))
    )
)

(:durative-action desinfectar
    :parameters (?l - lift)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (not (desinfectado ?l))
        ))
    )
    :effect (and 
        (at end (and 
            (desinfectado ?l)
        ))
    )
)

)