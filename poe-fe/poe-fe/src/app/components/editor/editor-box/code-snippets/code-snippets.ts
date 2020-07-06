/**
 * Predefined blocks of code to be added to the editor
 */
export const snippets = {
  domainSqueleton: `
  ; Change the domain name to the one you will use in your problems
  (define (domain your_domain_name)

  ; Requirements
  (:requirements :strips :fluents :durative-actions :typing :negative-preconditions :equality)

  ; Types
  (:types
    ; dog cat - animal
  )

  (:predicates )

  ; Define your funtions
  (:functions )

  ; Add the actions

  )\n`,

  problemSqueleton: `
  ; Make sure you write the same domain name than the given in the domain definition
  (define (problem your_problem_name) (:domain your_domain_name)

  ; Objects definition
  (:objects
  )

  ; Initial state
  (:init
    ;...
  )

  ; Goal
  (:goal (and
      ; ...
  ))

  ; Metric if any
  ;(:metric minimize (
    ; total-time
  ))
  )\n`,

  basicAction: `
  (:action action_name
    :parameters ()
    :precondition (and )
    :effect (and )
  )
  `,

  durativeAction: `
  (:durative-action action_name
    :parameters ()
    :duration (= ?duration 1)
    :condition (and
        (at start (and
        ))
        (over all (and
        ))
        (at end (and
        ))
    )
    :effect (and
        (at start (and
        ))
        (at end (and
        ))
    )
  )
  `
};
