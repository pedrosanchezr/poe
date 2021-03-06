import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { EditorComponent } from './components/editor/editor.component';
import { RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

// Code Mirror
import { CodemirrorModule } from '@ctrl/ngx-codemirror';
import '../assets/codemirror/pddl-mode';
import 'codemirror/addon/edit/closebrackets.js';
import 'codemirror/addon/edit/matchbrackets.js';
import { ToolbarComponent } from './components/toolbar/toolbar.component';
import { EditorBoxComponent } from './components/editor/editor-box/editor-box.component';

@NgModule({
  declarations: [
    AppComponent,
    EditorComponent,
    ToolbarComponent,
    EditorBoxComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    RouterModule,
    CodemirrorModule,
    FormsModule,
    HttpClientModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
