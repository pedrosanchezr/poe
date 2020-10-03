export const blocksworldDomain1 = `; From: https://cse3521.artifice.cc/pddl.html
; (Published under Creative Commons Attribution-ShareAlike 3.0 Unported License. by Joshua Eckroth)
;
; Note: It seems that this implementation has no (hand-empty) check.
; Pending to create one with this check

(define (domain blocksworld)
  (:requirements :strips)

  (:predicates (clear ?x)
               (on-table ?x)
               (holding ?x)
               (on ?x ?y))

  (:action pickup
           :parameters (?ob)
           :precondition (and (clear ?ob) (on-table ?ob))
           :effect (and (holding ?ob) (not (clear ?ob)) (not (on-table ?ob))))

  (:action putdown
           :parameters (?ob)
           :precondition (and (holding ?ob))
           :effect (and (clear ?ob) (on-table ?ob) 
                        (not (holding ?ob))))

  (:action stack
           :parameters (?ob ?underob)
           :precondition (and  (clear ?underob) (holding ?ob))
           :effect (and (clear ?ob) (on ?ob ?underob)
                        (not (clear ?underob)) (not (holding ?ob))))

  (:action unstack
           :parameters (?ob ?underob)
           :precondition (and (on ?ob ?underob) (clear ?ob))
           :effect (and (holding ?ob) (clear ?underob)
                        (not (on ?ob ?underob)) (not (clear ?ob)))))
`;

export const blocksworldProblem1 = `; From: https://cse3521.artifice.cc/pddl.html 
; (Published under Creative Commons Attribution-ShareAlike 3.0 Unported License. by Joshua Eckroth)


(define (problem blocksworld-prob2)
  (:domain blocksworld)
  (:objects a b)
  (:init 
    (on-table a) ; The block A is on the table
    (on-table b) ; The block B is on the table
    (clear a)    ; There are no blocks on top of A
    (clear b)    ; There are no blocks on top of B
  )
  (:goal (and
    (on a b)     ; Our objective is to have A on top of B
  )))
`;

export const blocksworldProblem2 = `(define (problem blocksworld-prob2)
(:domain blocksworld)
(:objects a b c d)	; We have 4 blocks
(:init
  (on-table a) ; The object A is on the table
  (on-table b) ; The object B is on the table
  (on c a)	   ; C is on top of A
  (on d b)	   ; D is on top of B
  (clear c)    ; There are no objects on top of C
  (clear d)    ; There are no objects on top of D
)
(:goal (and
  (on a b)     ; Our objective is to have A on top of B
))
)`;

export const blocksworldProblem3 = `(define (problem blocksworld-prob3)
(:domain blocksworld)
(:objects a b c d)	; We have 4 blocks
(:init
  (on-table a) ; The object A is on the table
  (on-table b) ; The object B is on the table
  (on c a)	   ; C is on top of A
  (on d b)	   ; D is on top of B
  (clear c)    ; There are no objects on top of C
  (clear d)    ; There are no objects on top of D
)
(:goal (and
  (on a b)
  (on d a)     ; Our objective is to have A on top of B and D on top of A
))
)`;
