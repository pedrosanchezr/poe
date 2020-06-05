(define (problem five-levels) (:domain building)
(:objects 
    l1 l2 - slowlift
    l3 l4 - fastlift
    n0 n1 n2 n3 n4 n5 - num
    ANA - person
)

(:init
    ; Init numbers
    (next n0 n1) (next n1 n2)  (next n2 n3)   (next n3 n4)  (next n4 n5)
    ; Init lifts 1 & 2 (SLOW)
    (lift-at l1 n4)             (lift-at l2 n1)
    (people-in-lift l1 n0)      (people-in-lift l2 n0)
    (can-stop-at l1 n0)         (can-stop-at l2 n0)
    (can-stop-at l1 n1)         (can-stop-at l2 n1)
    (can-stop-at l1 n2)         (can-stop-at l2 n2)
    (can-stop-at l1 n3)         (can-stop-at l2 n3)
    (can-stop-at l1 n4)         (can-stop-at l2 n4)
    (can-stop-at l1 n5)         (can-stop-at l2 n5)
    ; Init lifs 3 & 4 (FAST)
    (lift-at l3 n0)             (lift-at l4 n2)
    (people-in-lift l3 n0)      (people-in-lift l4 n0)
    (can-stop-at l3 n0)         (can-stop-at l4 n0)
    (can-stop-at l3 n2)         (can-stop-at l4 n2)
    (can-stop-at l3 n4)         (can-stop-at l4 n4)
    ; Init people
    (person-at ANA n2)
    ; Setting up constants
    (= (time-per-floor-fastlift) 21)
    (= (time-per-floor-slowlift) 3)
    (= (t-embarque) 5)
)

(:goal (and
    (person-at ANA n0)
))

(:metric minimize (total-time))
)
