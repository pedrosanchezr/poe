; Author: Pedro Sánchez
;

(define (domain cooperation)

(:requirements :strips :fluents :durative-actions :disjunctive-preconditions :typing :equality :constraints :preferences)

(:types
    Geopositioned - object          ; Type of object that can be located using coordinates
    Vehicle - Geopositioned         ; A Vehicule can be positioned in the map
    UAV UGV - Vehicle               ; UAV and UGV are Vehicles
    NavMode                         ; Modes of navigation
    Pan                             ; Pan options
    Tilt                            ; Tilt options
    FixLocation - Geopositioned     ; Fix location (can be positioned but not moved) i.e. Base location, targets...
    Base - FixLocation              ; Base ar fixed locations
    Coordinates                     ; Coordinates object to indicate the reacheable map positions
)

(:predicates
    (in-dock ?v - Vehicle)                              ; The vehicle V is on its dock
    (navmode ?v - Vehicle ?n - NavMode)                 ; The vehicle V has set the NavMode N
    (cam-orientation ?v - Vehicle ?p - Pan ?t - Tilt)   ; The orientation of the camera at vehicle V is pan = P and tilt = T
    (base-station ?v - Vehicle ?b - Base)            ; The base of the vehicle V is B
    (available ?v - Vehicle)                                 ; The vehicle V is available to perform an action (opposite of busy, to avoid negative preconditions due to Optic compatibility issue) 
    (at-pos ?gp - Geopositioned ?coor - Coordinates)        ; Pos of a Geopositioned object is the given Coordinate
    (photo-taken ?v - Vehicle ?c - Coordinates ?p - Pan ?t - Tilt)    ; A photo was taken by the Vehicle V at Coordinate C with the orientation ?PAN and ?TILT
    (photo-received ?c - Coordinates ?p - Pan ?t - Tilt)    ; A photo from the given Coord with the right orientation was received
    (allowed-pan ?p1 ?p2 - Pan)     ; Next pan allowed - I used to have a (next P1 P2) and checks for (or (next P1 P2) (next P2 P1)), but this caused problems
    (allowed-tilt ?t1 ?t2 - Tilt)   ; Next tild allowed - Same as before. When checking for moving to next, previous or same tilt, it failed and as we have the change of pan and tilt at the same place, we must allow keeping one unchanged
)


(:functions
    (time-per-distance ?n - NavMode)    ; Time required per unit of distance on the given mode 
    (energy-per-distance ?n - NavMode)  ; Energy required per unit of distance on the given mode
    (energy-level ?v - Vehicle)                   ; Amount of energy of the vehicle
    (energy-required-docking)           ; Energy required to dock or undock 
    (energy-per-charge-unit)              ; Amount of batery charged per unit of time
    (energy-navmode-change)              ; Energy required to change the navmode
    (distance ?from ?to - Coordinates)       ; Distance between 2 Coordinates
    (time-take-photo)                    ; Time required to take a photo
    (energy-per-photo)                      ; Energy required to take a photo
    (time-to-send-photo)                    ; Time required to send a photo
    (energy-to-send-photo)                      ; Energy required to send a photo
    (time-to-orientate)                     ; Time to change orientation
    (energy-to-orientate)                     ; Energy required to change orientation
    (total-energy-used)                     ; Acummulator of total energy consumed
    (metric-factor-time)                                    ; Factor to be aplied to the metric = time
    (metric-factor-energy)                                    ; Factor to be aplied to the metric = energy 
    (metric-factor-uav-not-base)                            ; Factor for violation of UAV NOT DOCK preference
    (metric-factor-ugv-not-base)                            ; Factor for violation of UGV NOT DOCK preference
)

(:durative-action dock
    :parameters (?v - Vehicle ?b - Base ?coord - Coordinates)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (at-pos ?v ?coord)          ; The vehicle is at the given coordinates
            (at-pos ?b ?coord)          ; The base is at the given coordinates
            (base-station ?v ?b)        ; B must be the base station of V
            (available ?v)             ; V is not busy
            (>= (energy-level ?v) (energy-required-docking)) ; The vehicle has enough batery to dock or undock
        ))
    )
    :effect (and 
        (at start (and
            (not (available ?v))       ; The vehicle is busy performing an action
        ))
        (at end (and
            (available ?v) ; The vehicle is free to perform more actions
            (in-dock ?v)    ; The vehicle is now docked
            (decrease (energy-level ?v) (energy-required-docking))  ; Decrease the batery level due to the action performed
            (increase (total-energy-used) (energy-required-docking))    ; Increase the accummulator of total-energy
        ))
    )
)

(:durative-action undock
    :parameters (?v - Vehicle ?b - Base)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (base-station ?v ?b)        ; B must be the base station of V
            (in-dock ?v)                ; V is docked
            (available ?v)             ; V is not busy
            (>= (energy-level ?v) (energy-required-docking)) ; The vehicle has enough batery to dock or undock
        ))
    )
    :effect (and 
        (at start (and
            (not (available ?v))               ; The vehicle is busy performing an action
        ))
        (at end (and
            (available ?v)         ; The vehicle is free to perform more actions
            (not (in-dock ?v))      ; The vehicle is now docked
            (decrease (energy-level ?v) (energy-required-docking))      ; Decrease the batery level due to the action performed
            (increase (total-energy-used) (energy-required-docking))    ; Increase the accummulator of total-energy
        ))
    )
)

(:durative-action charge-batery
    :parameters (?v - Vehicle)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and
            (available ?v)
            (in-dock ?v) 
        ))
    )
    :effect (and 
        (at start (and 
            (not (available ?v))
        ))
        (at end (and 
            (available ?v)
            (increase (energy-level ?v) (energy-per-charge-unit))
        ))
    )
)


(:durative-action move
    :parameters (?v - Vehicle ?from ?to - Coordinates ?n - NavMode)
    :duration (= ?duration (* (time-per-distance ?n) (distance ?from ?to)))
    :condition (and 
        (at start (and 
            ; Commenting out this line to work with optic planner, as this means that the robot can move even docked, I'll implicitly undock it on effects
            ;(not (in-dock ?v))      ; The vehicle is not attached to the dock
            (navmode ?v ?n)         ; The vehicle must have the required navmode selected
            (available ?v)         ; The vehicle must be available
            (>= (energy-level ?v) (* (energy-per-distance ?n) (distance ?from ?to)))  ; The vehicle has enough batery to move to the next position
            (at-pos ?v ?from)       ; Vehicle is at FROM position         
            (not (= ?from ?to))     ; From and to are different
        ))
    )
    :effect (and 
        (at start (and 
            (not (in-dock ?v))      ; Forcing to un-dock as now we cannot have negative preconditions
            (not (available ?v))               ; The vehicle is performing an action
            (not (at-pos ?v ?from)) ; Vehicle is no longer at the FROM position
        ))
        (at end (and 
            (at-pos ?v ?to)         ; Vehicle is now at TO position
            (available ?v)         ; The vehicle is no longer busy
            (decrease (energy-level ?v) (* (energy-per-distance ?n) (distance ?from ?to)))  ; Decrease the batery level due to the action performed
            (increase (total-energy-used) (* (energy-per-distance ?n) (distance ?from ?to)))    ; Increase the accummulator of total-energy
        ))
    )
)

(:durative-action set-navmode
    :parameters (?v - Vehicle ?n1 ?n2 - NavMode)
    :duration (= ?duration 2)
    :condition (and 
        (at start (and
            (navmode ?v ?n1)        ; The navmode selected must be the one of the second argument
            ; Commenting out next line to be compatible with Optic (no negative preconditions)
            ;(not (= ?n1 ?n2))       ; The navmode must be different to the current one
            (available ?v)          ; The vehicle must be available
            (>= (energy-level ?v) (energy-navmode-change)) ; We need to have enough energy to perform the action
        ))
    )
    :effect (and
        (at start (and 
            (not (available ?v))       ; The vehicle is performing an action
        ))
        (at end (and 
            (navmode ?v ?n2)         ; The navmode is changed now
            (not (navmode ?v ?n1))   ; The navmode is no longer ?n1
            (available ?v)          ; The vehicle is no longer busy
            (decrease (energy-level ?v) (energy-navmode-change))      ; Decrease the batery level due to the action performed
            (increase (total-energy-used) (energy-navmode-change))    ; Increase the accummulator of total-energy
        ))
    )
)

(:durative-action take-photo
    :parameters (?v - Vehicle ?coord - Coordinates ?p - Pan ?t - Tilt)
    :duration (= ?duration (time-take-photo))
    :condition (and 
        (at start (and 
            (available ?v)                             ; Vehicle not busy
            (at-pos ?v ?coord)                          ; Vehicle at the required position
            (cam-orientation ?v ?p ?t)                  ; Camera at right orientation
            (>= (energy-level ?v) (energy-per-photo))   ; The vehicle has enough energy
        ))
    )
    :effect (and 
        (at start (and 
            (not (available ?v))   ; Vehicle becomes busy
        ))
        (at end (and 
            (increase (total-energy-used) (energy-per-photo))    ; Increase the accummulator of total-energy
            (decrease (energy-level ?v) (energy-per-photo))      ; Decrease the energy
            (photo-taken ?v ?coord ?p ?t)                        ; The vehicle has the photo with the given parameters
            (available ?v)                                      ; Vehicle is no longer busy
        ))
    )
)

(:durative-action transmit-photo
    :parameters (?v - Vehicle ?coord - Coordinates ?p - Pan ?t - Tilt)
    :duration (= ?duration (time-to-send-photo))
    :condition (and 
        (at start (and 
            ; Assuming that we can transmit photos at any point in the map, not only at base
            (available ?v)                                 ; Vehicle must be available
            (photo-taken ?v ?coord ?p ?t)                   ; The vehicle has the required photo
            (>= (energy-level ?v) (energy-to-send-photo))   ; The vehicle has enough energy
        ))
    )
    :effect (and 
        (at start (and 
            (not (available ?v))       ; Vehicle becomes busy
        ))
        (at end (and 
            (available ?v)                                         ; Vehicle is no longer busy
            (decrease (energy-level ?v) (energy-to-send-photo))     ; Decrease the energy
            (increase (total-energy-used) (energy-to-send-photo))   ; Increase the accummulator of total-energy
            (photo-received ?coord ?p ?t)                           ; Photo was successfuly sent
        ))
    )
)

(:durative-action change-orientation
    :parameters (?v - Vehicle ?p1 ?p2 - Pan ?t1 ?t2 - Tilt)
    :duration (= ?duration (time-to-orientate))
    :condition (and 
        (at start (and 
            (available ?v)                                  ; Vehicle must be available
            (cam-orientation ?v ?p1 ?t1)                    ; Vehicule has the initial orientation
            (>= (energy-level ?v) (energy-to-send-photo))   ; The vehicle has enough energy
            (allowed-pan ?p1 ?p2)                           ; P2 must be a valid value starting in P1
            (allowed-tilt ?t1 ?t2)                          ; T2 must be a valid value starting in T1
        ))
    )
    :effect (and 
        (at start (and 
            (not (available ?v))                           ; Vehicle becomes busy
            (not (cam-orientation ?v ?p1 ?t1))  ; The orientation is no longer the initial one
        ))
        (at end (and 
            (available ?v)                                         ; Vehicle is no longer busy
            (decrease (energy-level ?v) (energy-to-orientate))      ; Decrease the energy
            (increase (total-energy-used) (energy-to-orientate))    ; Increase the accummulator of total-energy
            (cam-orientation ?v ?p2 ?t2)                            ; Orientation changed to target one
        ))
    )
)

)
