import { Component, OnInit, Input, ViewChild } from '@angular/core';
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

  /** Editor title */
  @Input() content: string;

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

  constructor() { }

  ngOnInit(): void {
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
}
