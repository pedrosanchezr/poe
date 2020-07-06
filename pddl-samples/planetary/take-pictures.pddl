(define (problem take-pictures) (:domain planetary)
    (:objects 
        r1 - robot
        A B C - point
        takePicture gatherSample - task
    )

    (:init
        ; Init points
        (accesible A B)         (accesible B A)
        (accesible B C)         (accesible C B)
        (= (distance A B) 30)   (= (distance B A) 30)
        (= (distance B C) 20)   (= (distance C B) 20)
        ; Init tasks
        (= (task-time takePicture) 10)
        (= (task-time gatherSample) 20)
        (= (task-batery-needed takePicture) 25)
        (= (task-batery-needed gatherSample) 40)
        ; Init robots
        (= (max-batery r1) 100)
        (= (batery-level r1) 0)
        (at r1 A)
        (= (distance-at-slow-speed r1) 1)        ; Amount of distance units covered by unit of time - Slow (moving 4 units of distance requires 4/1 = 4 units of time)
        (= (distance-at-fast-speed r1) 4)        ; Amount of distance units covered by unit of time - Slow (moving 4 units of distance requires 4/4 = 1 unit of time)
        (= (batery-usage-at-slow-speed r1) 2)    ; Moving at slow speed is slower but uses less batery  (moving 4 units of distance requires 2*4 = 8 units of batery)
        (= (batery-usage-at-fast-speed r1) 6)    ; Moving at fast speed is faster put uses 3 times more batery (moving 4 units of distance requires 6*4 = 24 units of batery)
        (= (batery-charged-by-timeunit r1) 4)    ; The robot can charge N units of batery each time it stops for charging during 1 time unit
        ; Init places
        (free B)    (free C)
        ; Init tasks per robot and point
        (= (executed r1 takePicture A) 0)   (= (executed r1 takePicture B) 0)   (= (executed r1 takePicture C) 0)
        (= (executed r1 gatherSample A) 0)  (= (executed r1 gatherSample B) 0)  (= (executed r1 gatherSample C) 0)
    )

    (:goal (and
        ; Have 10 pictures of B and 3 samples of C
        (= (executed r1 takePicture B) 10)
        (= (executed r1 gatherSample C) 3)
    ))
)
