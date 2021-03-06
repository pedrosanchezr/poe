import { Component, OnInit, EventEmitter, Output } from '@angular/core';
import { globalVars } from 'src/environments/global_vars';
import { examples } from 'src/app/examples/_config';
import { ExampleSelected } from 'src/app/models/examples/ExampleSelected';
import { licenseLogo } from 'src/assets/logo-license';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-toolbar',
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.scss']
})
export class ToolbarComponent implements OnInit {
  /** Event to be triggered when the user selects a file from the computer to be loaded as Domain
   *  Propagate: File Input target
   */
  @Output() domainSelected = new EventEmitter<any>();

  /** Event to be triggered when the user selects a file from the computer to be loaded as Problem
   *  Propagate: File Input target
   */
  @Output() problemSelected = new EventEmitter<any>();

  /** Event to be triggered when the user clicks on download one of the editors
   *  Propagate: String with the editor to be downloaded (domain/problem)
   */
  @Output() downloadContent = new EventEmitter<string>();

  /** Event to be triggered when the user clicks on loading a example
   *  Propagate: <ExampleSelected> with the example to be loaded (for example group: "gripper_1", example: "simpleImplementation")
   */
  @Output() loadExample = new EventEmitter<ExampleSelected>();

  /** Version of the APP */
  public version = `${globalVars.appname} ${globalVars.version}`;

  /** Examples to be loaded in the "Examples" tab */
  public exContent = examples;

  /** Logo license text */
  public logoLicense = licenseLogo;

  /** Backend URL */
  // replacing https to http until flask restplus swagger is fixed on https
  public backendUrl = environment.api_url.replace('https', 'http');

  constructor() { }

  ngOnInit(): void {
  }

  /**
   * Open the file input hidding the html file input component to the user
   *
   * @param target Editor that the user wants to populate
   */
  public openFileExplorer(target: string) {
    switch (target) {
      case 'domain':
        document.getElementById('importDomain').click();
        break;
      case 'problem':
        document.getElementById('importProblem').click();
        break;
      default:
        console.log(`Invalid action performed (openFileExplorer) value received = (${target})`);
    }
  }

  /**
   * Trigger the event required to load the file on the editor
   *
   * @param event Event received from HTML file input
   * @param target Target editor (domain/problem)
   */
  public onFileSelected(event: any, target: string) {
    switch (target) {
      case 'domain':
        this.domainSelected.emit(event.target);
        break;
      case 'problem':
        this.problemSelected.emit(event.target);
        break;
      default:
        console.log(`Invalid action performed (onFileSelected) value received = (${target})`);
    }
  }

  /**
   * Trigger the event to download the content of editors
   *
   * @param editor Editor to be downloaded (problem/domain)
   */
  public onDownloadContent(editor: string) {
    this.downloadContent.emit(editor);
  }

  /**
   * Trigger the event to load the example choosen
   *
   * @param exampleSelected <ExampleSelected> with the example selected to be loaded
   */
  public onLoadExample(exampleSelected: ExampleSelected) {
    this.loadExample.emit(exampleSelected);
  }

  /**
   * Return the keys of an object in order to simplify iterations on maps/dicts
   * @param obj Object that we want to get the keys from
   */
  public getKeys(obj: object): string[] {
    return Object.keys(obj);
  }

  /**
   * Method to expand the example group dropdown to avoid using hover which is not good for touch screens
   * @param event Click event
   * @param key Key of the group clicked
   */
  public expandGroup(event: Event, key: string) {
    // Hide any group already expanded
    this.hideExpandedGroups();
    // Stop the click event propagation to avoid the dropdown to close
    event.stopPropagation();
    // Expand the submenu
    const subGroupItem = document.getElementById(`subgroup_${key}`);
    subGroupItem.style.display = 'block';
  }

  /**
   * Workaround to avoid expanded groups to remain expanded forever
   */
  public hideExpandedGroups() {
    for (const key in this.exContent) {
      if (this.exContent.hasOwnProperty(key)) {
        const subGroupItem = document.getElementById(`subgroup_${key}`);
        subGroupItem.style.display = 'none';
      }
    }
  }
}
