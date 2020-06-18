import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { PlannerService } from 'src/app/services/planner.service';
import { CodemirrorComponent } from '@ctrl/ngx-codemirror';

@Component({
  selector: 'app-editor',
  templateUrl: './editor.component.html',
  styleUrls: ['./editor.component.scss']
})
export class EditorComponent implements OnInit {
  public domainContent: string;
  public problemContent: string;
  public output = 'Execute your problem to get the output here...';
  public alertMessage = '';
  public buttonEnabledFlag = true;
  public lastPlanner: string;

  /** References to the editors */
  @ViewChild('editor', { static: true }) editor!: CodemirrorComponent;

  /** Selected Theme */
  public selectedTheme = 'abcdef';

  /** Object with the editor options */
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

  /** Themes available */
  public themes = [
    'abcdef',
    '3024-day',
    '3024-night',
    'ambiance-mobile',
    'ambiance',
    'ayu-dark',
    'ayu-mirage',
    'base16-dark',
    'base16-light',
    'bespin',
    'blackboard',
    'cobalt',
    'colorforth',
    'darcula',
    'dracula',
    'duotone-dark',
    'duotone-light',
    'eclipse',
    'elegant',
    'erlang-dark',
    'gruvbox-dark',
    'hopscotch',
    'icecoder',
    'idea',
    'isotope',
    'lesser-dark',
    'liquibyte',
    'lucario',
    'material',
    'material-darker',
    'material-ocean',
    'material-palenight',
    'mbo',
    'mdn-like',
    'midnight',
    'monokai',
    'moxer',
    'neat',
    'neo',
    'night',
    'nord',
    'oceanic-next',
    'panda-syntax',
    'paraiso-dark',
    'paraiso-light',
    'pastel-on-dark',
    'railscasts',
    'rubyblue',
    'seti',
    'shadowfox',
    'solarized',
    'ssms',
    'the-matrix',
    'tomorrow-night-bright',
    'tomorrow-night-eighties',
    'ttcn',
    'twilight',
    'vibrant-ink',
    'xq-dark',
    'xq-light',
    'yeti',
    'yonce',
    'zenburn',
  ];

  constructor(private plannerService: PlannerService) { }

  ngOnInit(): void {
  }

  public executeInSGPlan(timeout: number) {
    this.plannerService.executeInSGplan(this.domainContent, this.problemContent, timeout).subscribe(
      (res) => {
        this.output = res;
        this.alertMessage = '';
        // Reenable the button once the response is received
        this.buttonEnabledFlag = true;
      },
      (err) => {
        console.log(err);
        this.alertMessage = err.message;
        // Reenable the button if error received
        this.buttonEnabledFlag = true;
      }
    );
  }

  public executeInOptic(timeout: number) {
    this.plannerService.executeInOptic(this.domainContent, this.problemContent, timeout).subscribe(
      (res) => {
        this.output = res;
        this.alertMessage = '';
        // Reenable the button once the response is received
        this.buttonEnabledFlag = true;
      },
      (err) => {
        console.log(err);
        this.alertMessage = err.message;
        // Reenable the button if error received
        this.buttonEnabledFlag = true;
      }
    );
  }

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

  public onThemeChanged(event) {
    this.editorOptions.theme = this.selectedTheme;
  }
}
