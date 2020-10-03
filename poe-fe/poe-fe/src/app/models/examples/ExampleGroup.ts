import { ExampleConfigItem } from './ExampleConfigItem';

/**
 * Class that defines each group of examples
 */
export class ExampleGroup {
  /** Title to be displayed in the UI */
  title: string;
  /** Map of items to be included in the dropdown */
  items: {[id: string]: ExampleConfigItem};
}
