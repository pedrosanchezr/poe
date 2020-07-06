; Planetary domain
; Author: Pedro Sánchez
(define (domain planetary)

    (:requirements :strips :fluents :durative-actions :negative-preconditions :typing :equality)

    (:types 
        point
        robot
        task
    )

    (:predicates
        (at ?r - robot ?p - point)      ; The robot ?r is at point ?p
        (accesible ?a ?b - point)    ; The point ?b is accesible from point ?a
        (busy ?r - robot)            ; Robot ?r is busy (cannot start other task until finished)
        (free ?p - point)            ; No robot is at the point ?p, so we can get there (only one robot can be at a given point)
    )


    (:functions
        (distance ?a ?b - point)        ; Indicates the distance starting from ?a and finishing at ?b
        (batery-level ?r - robot)               ; Indicates the batery level of the robot ?r
        (executed ?r - robot ?t - task  ?p - point)             ; Indicates the number of times that the robot ?r executed the task ?t on point ?p
        (task-time ?t - task)            ; Indicates the time that takes to execute the given task
        (task-batery-needed ?t - task)      ; Indicates the amount of batery needed to execute a given task
        (max-batery ?r - robot)                  ; Max amount of batery that the robot ?r can store
        ; Setup functions (functions to setup the constant values)
        (distance-at-slow-speed ?r - robot)             ; Sets the amount of distance units when the robot ?r moves at slow speed
        (distance-at-fast-speed ?r - robot)             ; Sets the amount of distance units when the robot ?r moves at slow speed
        (batery-usage-at-slow-speed ?r - robot)                 ; Sets the amount of batery that the robot will use for each distance unit at slow speed
        (batery-usage-at-fast-speed ?r - robot)                    ; Sets the amount of batery that the robot will use for each distance unit at slow speed
        (batery-charged-by-timeunit ?r - robot)                     ; Sets the amount of batery that is charged for each unit of time stop using the solar panes
    )

    ; Actions
    (:durative-action move-slow
        :parameters (?a ?b - point ?r - robot)
        :duration (= ?duration (/ (distance ?a ?b) (distance-at-slow-speed ?r)))    ; The unit for the duration will be the distance / the "speed" (distance/unit of duration)
        :condition 
        (and
            (at start (and
                (accesible ?a ?b)                               ; Point B is accesible from point A
                (not (busy ?r))                                 ; Robot is not busy
                (at ?r ?a)                                      ; Robot is at source point
                (>= (batery-level ?r) (* (batery-usage-at-slow-speed ?r) (distance ?a ?b)))   ; We will use N units of batery for each unit of distance at slow mode    
            ))
            (at end 
                (free ?b)       ; The destination is not already covered by other robot
            )
        )
        :effect (and 
            (at start (and
                (busy ?r)           ; The robot is busy so will not take any other action until finishing this one
                (not (at ?r ?a))    ; Robot is no longer at A, now is on its way to B
                (free ?a)           ; Set the source point as free (this robot is leaving this place)
            ))
            (at end (and
                (not (busy ?r))                                         ; Robot is no longer busy
                (at ?r ?b)                                              ; Robot is at B
                (not (free ?b))                                         ; Point B is covered by robot R
                (decrease (batery-level ?r) (* (batery-usage-at-slow-speed ?r) (distance ?a ?b)))     ; Decrease the batery level
            ))
        )

    )

    (:durative-action move-fast
        :parameters (?a ?b - point ?r - robot)
        :duration (= ?duration (/ (distance ?a ?b) (distance-at-fast-speed ?r)))    ; The unit for the duration will be the distance / the "speed" (distance/unit of duration)
        :condition 
        (and
            (at start (and
                (accesible ?a ?b)                               ; Point B is accesible from point A
                (not (busy ?r))                                 ; Robot is not busy
                (at ?r ?a)                                      ; Robot is at source point
                (>= (batery-level ?r) (* (batery-usage-at-fast-speed ?r) (distance ?a ?b)))   ; We will use N units of batery for each unit of distance at fast mode    
            ))
            (at end 
                (free ?b)       ; The destination is not already covered by other robot
            ) 
        )
        :effect (and 
            (at start (and
                (busy ?r)           ; The robot is busy so will not take any other action until finishing this one
                (not (at ?r ?a))    ; Robot is no longer at A, now is on its way to B
                (free ?a)           ; Set the source point as free (this robot is leaving this place)
            ))
            (at end (and
                (not (busy ?r))                                         ; Robot is no longer busy
                (at ?r ?b)                                              ; Robot is at B
                (not (free ?b))                                         ; Point B is covered by robot R
                (decrease (batery-level ?r) (* (batery-usage-at-fast-speed ?r) (distance ?a ?b)))     ; Decrease the batery level
            ))
        )
    )

    (:durative-action execute-task
        :parameters (?r - robot ?t - task ?p - point)
        :duration (= ?duration (task-time ?t))
        :condition (and 
            (at start (and 
                (not (busy ?r))                                 ; Robot must not be busy
                (at ?r ?p)                                      ; Robot ?r must be at point ?p
                (>= (batery-level ?r) (task-batery-needed ?t))  ; Has enough batery to perform the task
            ))
            ; No conditions over-all
            ; No conditions at end
        )
        :effect (and 
            (at start (and 
                (busy ?r)       ; Robot is busy, cannot do anything else
            ))
            (at end (and 
                (not (busy ?r))                                         ; Robot is no longer busy
                (increase (executed ?r ?t ?p) 1)                        ; Robot ?r executed the task ?t one more time
                (decrease (batery-level ?r) (task-batery-needed ?t))    ; Reduce the batery depending on the task
            ))
        )
    )

    ; Using some sort of solar panels
    ; Takes 1 time unit
    (:durative-action charge-bateries 
        :parameters (?r - robot)
        :duration (= ?duration 1)
        :condition (and 
            (at start (and 
                (not (busy ?r))                         ; Robot cannot be performing other tasks
                (< (batery-level ?r) (max-batery ?r))   ; The batery cannot be fully charged
            ))
            (at end (and 
                (<= (batery-level ?r) (max-batery ?r))  ; We cannot charge the batery more than its limit
            ))
        )
        :effect (and 
            (at start (and 
                (busy ?r)   ; Robot is busy
            ))
            (at end (and 
                (increase (batery-level ?r) (batery-charged-by-timeunit ?r))          ; The batery gets loaded by N units
                (not (busy ?r))                                                       ; The robot is no longer busy
            ))
        )
    )
)
