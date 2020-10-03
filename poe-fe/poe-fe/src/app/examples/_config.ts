import { blocksworldDomain1, blocksworldProblem1, blocksworldProblem2, blocksworldProblem3 } from './blocksworld_1';
import { gripperDomain1, gripperProblem1 } from './gripper_1';
import { ExampleGroup } from '../models/examples/ExampleGroup';

/**
 * Configuration map used to import the examples
 *
 * For now it force you to follow the current structure (so no direct links from first level nor more than 2 levels).
 * In order to keep it clean, do not enter the text directly here. Implement it in a separate file and import it.
 *
 * I'm using maps/dictionaries instead of lists of items or lists of examples to allow direct access by the id to the selected element
 * Example: examples['blocks_1'].items['stacking'].domain
 */
export const examples: {[id: string]: ExampleGroup} = {
  blocks_1: {
    title: 'Blocks World (Basic)',
    items: {
      stacking: {
        title: 'Stacking blocks',
        domain: blocksworldDomain1,
        problem: blocksworldProblem1
      },
      unstacking: {
        title: 'Unstacking and stacking',
        domain: blocksworldDomain1,
        problem: blocksworldProblem2
      },
      multiGoal: {
        title: 'Example with multiple goals',
        domain: blocksworldDomain1,
        problem: blocksworldProblem3
      }
    }
  },
  gripper_1: {
    title: 'Getting started - UAH',
    items: {
      gripper: {
        title: 'Gripper',
        domain: gripperDomain1,
        problem: gripperProblem1
      }
    }
  }
};

