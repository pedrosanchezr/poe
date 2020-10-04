import { Component, OnInit } from '@angular/core';
import { PlannerService } from 'src/app/services/planner.service';
import { environment } from 'src/environments/environment';
import { config } from 'rxjs';
import { examples } from 'src/app/examples/_config';
import { ExampleSelected } from 'src/app/models/examples/ExampleSelected';

@Component({
  selector: 'app-editor',
  templateUrl: './editor.component.html',
  styleUrls: ['./editor.component.scss']
})
export class EditorComponent implements OnInit {
  /** Content of the domain editor */
  public domainContent: string;
  /** Content of the problem editor */
  public problemContent: string;
  /** Content of the output console */
  public output = 'Execute your problem to get the output here...';
  /** Variable used to display error messages */
  public alertError = '';
  /** Variable used to display warning messages */
  public alertWarning = '';
  /** Flag to determine if the run button will be enabled */
  public buttonEnabledFlag = true;
  /** Variable to hold the name of the latest planer used */
  public lastPlanner: string;

  /** Selected Theme */
  public selectedTheme = 'abcdef';

  /** Themes available */
  public themes = environment.themesAvailable;

  /** Editor options (create 2 if they are different at some point) */
  public editorOptions = {
    lineNumbers: true,
    theme: 'abcdef',
    mode: 'pddl',
    setSize: '700px',
    matchingbracket: true,
    dragDrop: true,
    smartIndent: true,
    autoCloseBrackets: true,
    matchBrackets: true
  };

  constructor(private plannerService: PlannerService) { }

  ngOnInit(): void {
  }

  /**
   * Quick and dirty solution to remove the start and end quotes if they come in the server response
   *
   * @param str STR without the initial and final quotes if any
   * @returns String with the start and end quotes removed if any
   */
  private trimQuotes(str: string): string {
    let newstr = str;

    if (newstr[0] === '"') {
      newstr = newstr.substring(1);
    }

    if (newstr[newstr.length - 1] === '"') {
      newstr = newstr.substring(0, -1);
    }

    return newstr;
  }

  /**
   * Execute the code in SGPlan planner
   *
   * @param timeout Timeout for the Backend execution
   */
  public executeInSGPlan(timeout: number) {
    this.plannerService.executeInSGplan(this.domainContent, this.problemContent, timeout).subscribe(
      (res) => {
        this.output = this.trimQuotes(res);
        this.alertError = '';
        // Reenable the button once the response is received
        this.buttonEnabledFlag = true;
      },
      (err) => {
        console.log(err);
        this.alertError = err.message;
        // Reenable the button if error received
        this.buttonEnabledFlag = true;
      }
    );
  }

  /**
   * Execute the code in Optic planner
   *
   * @param timeout Timeout for the Backend execution
   */
  public executeInOptic(timeout: number) {
    this.plannerService.executeInOptic(this.domainContent, this.problemContent, timeout).subscribe(
      (res) => {
        this.output = res;
        this.alertError = '';
        // Reenable the button once the response is received
        this.buttonEnabledFlag = true;
      },
      (err) => {
        console.log(err);
        this.alertError = err.message;
        // Reenable the button if error received
        this.buttonEnabledFlag = true;
      }
    );
  }

  /**
   * Execute the code in the given planner with the timeout decided
   *
   * @param selectedPlanner Planner selected (sgplan/optic)
   * @param timeout Timeout to be given to the Backend
   */
  public execute(selectedPlanner: string, timeout: number) {
    // Disable the button
    this.buttonEnabledFlag = false;
    this.lastPlanner = selectedPlanner;
    // Executes the planner
    switch (selectedPlanner) {
      case 'sgplan': this.executeInSGPlan(timeout); break;
      case 'optic': this.executeInOptic(timeout); break;
      default: console.log(`Planner ${selectedPlanner} not implemented`);
    }
  }

  /**
   * Actions to be performed when the user changes the selection for the Theme
   *
   * @param event Event received from the dropdown of themes
   */
  public onThemeChanged(event: any) {
    this.editorOptions.theme = this.selectedTheme;
  }

  /**
   * Import the file in the target editor
   *
   * @param eventTarget Target of File Input
   * @param targetEditor Editor selected (domain/problem)
   */
  public importFile(eventTarget: any, targetEditor: string) {
    console.log('IMPORTING');

    const reader = new FileReader();

    reader.onload = (event) => {
        const content = event.target.result;
        switch (targetEditor) {
          case 'domain':
            this.domainContent = content as string;
            break;
          case 'problem':
            this.problemContent = content as string;
            break;
          default:
            console.log(`Invalid target used in importFile. Target = (${targetEditor})`);
        }
    };

    reader.readAsText(eventTarget.files[0]);
  }

  /**
   * Download the content of an editor as a PDDL file
   *
   * @param editor Editor selected (domain/problem)
   */
  public downloadContent(editor: string) {
    let blob: any;

    // Prepare the blob using the content of the selected editor
    switch (editor) {
      case 'domain':
        blob = new Blob([this.domainContent], { type: 'text/csv' });
        break;
      case 'problem':
        blob = new Blob([this.problemContent], { type: 'text/csv' });
        break;
      default:
        console.log(`Invalid target used in downloadContent. Target = (${editor})`);
    }

    // Download the blob
    // To be changed to a most clear way to download the content
    const fakeanchor: any = document.createElement('a');
    fakeanchor.href = URL.createObjectURL(blob);
    fakeanchor.download = `poe_${editor}.pddl`;
    fakeanchor.click();
    console.log(fakeanchor);
  }


  /**
   * Load the example selected into the editors
   *
   * @param ex <ExampleSelected> with a valid code example
   */
  public loadExample(ex: ExampleSelected) {
    // If there is content on some editor, show a warning for this
    if ((this.domainContent && this.domainContent.length > 0) || (this.problemContent && this.problemContent.length > 0)) {
      this.alertWarning = 'Your editors were not empty before loading an example. Remember you can undo using (Ctrl + Z) on each editor.';
    }

    // Load the example
    if (ex.group in examples && ex.example in examples[ex.group].items) {
      this.domainContent = examples[ex.group].items[ex.example].domain;
      this.problemContent = examples[ex.group].items[ex.example].problem;
    } else {
      this.domainContent = `Sorry. The example selected is not available, try with a different one.
        Group requested = "${ex.group}"
        Example requested = "${ex.example}"

        If this issue continues please open an issue in the repository. (Check "about" tab)
      `;
    }
  }
}
