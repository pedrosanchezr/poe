import { Component, OnInit, Input, ViewChild, Output, EventEmitter } from '@angular/core';
import { CodemirrorComponent } from '@ctrl/ngx-codemirror';
import { snippets } from './code-snippets/code-snippets';

@Component({
  selector: 'app-editor-box',
  templateUrl: './editor-box.component.html',
  styleUrls: ['./editor-box.component.scss']
})
export class EditorBoxComponent implements OnInit {
  /** Editor title */
  @Input() title: string;

  /** Editor type (problem/domain) */
  @Input() type: string;

  /** Editor content input and output  for twoways binding*/
  @Input() content: string;
  @Output() contentChange = new EventEmitter<string>();

  /** Object with the editor options */
  @Input() editorOptions = {
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

  /** References to the editor */
  @ViewChild('editor', { static: true }) editor!: CodemirrorComponent;

  /** Flag to know the fullscreen state (Default = false) */
  @Input() fullscreen = false;
  @Output() fullscreenChange = new EventEmitter<boolean>();

  /**
   * Editor font size (in pt)
   */
  public fontSize = 10;

  constructor() { }

  ngOnInit(): void {
  }

  /**
   * Event to be executed when the ngModel change
   * @param newContent Content to be propagated
   */
  public onContentChanged(newContent: string) {
    this.contentChange.emit(newContent);
  }

  /**
   * Insert code block from predefined options
   *
   * @param option text with one of the options available
   */
  public insertCode(option: string) {
    switch (option) {
      case 'domain-squeleton':
        this.editor.codeMirror.replaceSelection(snippets.domainSqueleton);
        break;
      case 'problem-squeleton':
        this.editor.codeMirror.replaceSelection(snippets.problemSqueleton);
        break;
      case 'basic-action':
        this.editor.codeMirror.replaceSelection(snippets.basicAction);
        break;
      case 'durative-action':
        this.editor.codeMirror.replaceSelection(snippets.durativeAction);
        break;
      default:
        console.log(`Invalid option (${option}) for code insertion`);
    }
  }

  /**
   * Toogle the state of the fullscreen mode and emits the event
   */
  public onToogleFullscreen() {
    this.fullscreen = !this.fullscreen;
    this.fullscreenChange.emit(this.fullscreen);
  }

  /**
   * Increase font size
   */
  public increaseFontSize() {
    this.fontSize++;
  }

  /**
   * Decrease font size
   */
  public decreaseFontSize() {
    this.fontSize--;
  }
}
