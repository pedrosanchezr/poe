(define (problem coop-problem) (:domain cooperation)
(:objects 
    Follower0 - UAV
    Leader - UGV
    base1 base2 - Base
    
    N0 N1 - NavMode
    P_0 P_45 P_90 P_135 P_180 P_225 P_270 P_315 - Pan
    T_0 T_45 T_90 T_270 T_315 - Tilt

    P0000   P0202   P1613   - Coordinates
    P0610   P1002   P0509   - Coordinates
)

(:init
    ; Init distances
        ; Involving P0000
        (= (distance P0000 P1613) 5)    (= (distance P1613 P0000) 5)
        (= (distance P0000 P0202) 2)      (= (distance P0202 P0000) 2)
        (= (distance P0000 P0610) 8)     (= (distance P0610 P0000) 8)
        (= (distance P0000 P1002) 6)     (= (distance P1002 P0000) 6)
        (= (distance P0000 P0509) 11)     (= (distance P0509 P0000) 11)
        ; Involving P0202 (without already defined)
        (= (distance P0202 P1613) 7)    (= (distance P1613 P0202) 7)
        (= (distance P0202 P0610) 5)     (= (distance P0610 P0202) 5)
        (= (distance P0202 P1002) 8)     (= (distance P1002 P0202) 8)
        (= (distance P0202 P0509) 6)      (= (distance P0509 P0202) 6)
        ; Involving P1613 (without already defined)
        (= (distance P1613 P0610) 3)   (= (distance P0610 P1613) 3)
        (= (distance P1613 P1002) 5)   (= (distance P1002 P1613) 5)
        (= (distance P1613 P0509) 8)    (= (distance P0509 P1613) 8)
        ; Involving P0610 (without already defined)
        (= (distance P0610 P1002) 5)    (= (distance P1002 P0610) 5)
        (= (distance P0610 P0509) 10)    (= (distance P0509 P0610) 10)
        ; Involving P1002 (without already defined)
        (= (distance P1002 P0509) 7)     (= (distance P0509 P1002) 7)
        ; Rest are already defined

    ; Init bases
    (at-pos base1 P0610)
    (at-pos base2 P1002)

    ; Init vehicles
    ;;;; Follower0
    (at-pos Follower0 P1002)                     ; Follower0 is at same position than base1
    (in-dock Follower0)                          ; In dock
    (base-station Follower0 base1)               ; Follower0 base station is Base1
    (= (energy-level Follower0) 1000)            ; Level of bateries
    (navmode Follower0 N0)                       ; Setting default navmode 0
    (cam-orientation Follower0 P_0 T_0)          ; Default camera orientation
    (available Follower0)                        ; As we had to change busy to available, we need to make sure we start as "available"
    ;;;; Leader
    (at-pos Leader P0610)                     ; Follower0 is at same position than base1
    (in-dock Leader)                          ; In dock
    (base-station Leader base1)               ; Follower0 base station is Base1
    (= (energy-level Leader) 1000)            ; Level of bateries
    (navmode Leader N0)                       ; Setting default navmode 0
    (cam-orientation Leader P_0 T_0)          ; Default camera orientation
    (available Leader)                        ; As we had to change busy to available, we need to make sure we start as "available"

    ; Init navmodes
    (= (time-per-distance N0) 4)
    (= (time-per-distance N1) 2)
    (= (energy-per-distance N0) 1)
    (= (energy-per-distance N1) 2)

    ; Other constants
    (= (energy-required-docking) 1)
    (= (energy-per-charge-unit) 5)
    (= (energy-navmode-change) 1)
    (= (time-take-photo) 5)
    (= (energy-per-photo) 10)
    (= (time-to-send-photo) 10)
    (= (energy-to-send-photo) 15)
    (= (time-to-orientate) 2)
    (= (energy-to-orientate) 2)
    (= (total-energy-used) 0)
    
    ; Added limitation to move between different PAN and TILT
    ; NEXT PAN | PREVIOUS PAN | KEEP SAME PAN
    (allowed-pan P_0 P_45)     (allowed-pan P_0 P_315)    (allowed-pan P_0 P_0)
    (allowed-pan P_45 P_90)    (allowed-pan P_45 P_0)     (allowed-pan P_45 P_45)
    (allowed-pan P_90 P_135)   (allowed-pan P_90 P_45)    (allowed-pan P_90 P_90)
    (allowed-pan P_135 P_180)  (allowed-pan P_135 P_90)   (allowed-pan P_135 P_135)
    (allowed-pan P_180 P_225)  (allowed-pan P_180 P_135)  (allowed-pan P_180 P_180)
    (allowed-pan P_225 P_270)  (allowed-pan P_225 P_180)  (allowed-pan P_225 P_225)
    (allowed-pan P_270 P_315)  (allowed-pan P_270 P_225)  (allowed-pan P_270 P_270)
    (allowed-pan P_315 P_0)    (allowed-pan P_315 P_270)  (allowed-pan P_315 P_315)

    (allowed-tilt T_0 T_45)     (allowed-tilt T_0 T_315)    (allowed-tilt T_0 T_0)
    (allowed-tilt T_45 T_90)    (allowed-tilt T_45 T_0)     (allowed-tilt T_45 T_45)
    (allowed-tilt T_90 T_270)   (allowed-tilt T_90 T_45)    (allowed-tilt T_90 T_90)
    (allowed-tilt T_270 T_315)  (allowed-tilt T_270 T_90)   (allowed-tilt T_270 T_270)
    (allowed-tilt T_315 T_0)    (allowed-tilt T_315 T_270)  (allowed-tilt T_315 T_315)

    ; Factor to apply to each metric in order to give a different weight to each
    ; time = 1 and energy = 2 means that for us energy counts double than time
    (= (metric-factor-time) 1)
    (= (metric-factor-energy) 2)
    (= (metric-factor-uav-not-base) 1)
    (= (metric-factor-ugv-not-base) 1)
   
)

(:goal (and
    (photo-received P0509 P_0 T_0)
    (photo-received P1613 P_0 T_0)
))

;(:constraints (and
;   ; THE ONES THAT SHOULD BE REQUIRED
;   (preference uavBase (always (at-pos Follower0 P1002))) ; As I don't have a predicate for at-base, just checking position
;   (preference ugvBase (sometime (at-pos Leader P0610))) ; As I don't have a predicate for at-base, just checking position
;))


; My old comment about multiple metrics seems not to be needed, in the PDDL3 slides it was explained
(:metric minimize 
    (+ 
        (* (total-time) (metric-factor-time))
        (* (total-energy-used) (metric-factor-energy))
;        (* (is-violated uavBase) (metric-factor-uav-not-base))
;        (* (is-violated ugvBase) (metric-factor-ugv-not-base))
    )
)

)
