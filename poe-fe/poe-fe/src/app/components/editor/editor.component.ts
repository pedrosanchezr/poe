import { Component, OnInit } from '@angular/core';
import { PlannerService } from 'src/app/services/planner.service';

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

  /** Selected Theme */
  public selectedTheme = 'abcdef';

  /** Object with the editor options */
  public editorOptions = {
    lineNumbers: true,
    theme: 'abcdef',
    mode: 'pddl',
    setSize: '700px'
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
      },
      (err) => {
        console.log(err);
        this.alertMessage = err.message;
      }
    );
  }

  public executeInOptic(timeout: number) {
    this.plannerService.executeInOptic(this.domainContent, this.problemContent, timeout).subscribe(
      (res) => {
        this.output = res;
        this.alertMessage = '';
      },
      (err) => {
        console.log(err);
        this.alertMessage = err.message;
      }
    );
  }

  public onThemeChanged(event) {
    this.editorOptions.theme = this.selectedTheme;
  }
}
