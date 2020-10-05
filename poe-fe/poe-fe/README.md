# Planning Online Editor (Frontend)

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 9.0.2.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory. Use the `--prod` flag for a production build.
Using `npm run build` will build it in production mode by default.

## Start in prod mode

Run `npm run start` to start a server with the content of `dist/`. The service will be `listening port 8080` by default.

## Generate Compodoc documentation

Run `npm run compodoc` to generate the documentation files. The output will be on `src/assets/doc`, run it before the build if you want it ot be included in your distribution.


# How to:

## How to deploy in your own server
- Modify the environment variable to point to the URL where you deployed the BE code. You will find the base url variable on `src/environments/environments.prod.ts`
- If you are using Heroku, the content of this project (and BE project) should be prepared to automatically compile and be deployed just pushing the content of the folder on your Heroku instance.
- If you are not using Heroku, just build the code and deploy it on a webserver of your choice following any advice for Angular applications or run `npm run start` to deploy on a simple node js webserver

## How to customize the app

- Replace the logo at `src/assets/logo.png` this should be a squaredish (don't have to be N:N exactly) logo.
- Replace the icon at `src/favicon.ico` with any other icon of your choice.
- If you changed the logo or icon, edit the content on `src/assets/logo-license.ts` so you can remove the current license content (change it to an empty string) or replace it with any attribution required for your logo.
- Replace the display name of the app (the one that will be displayed on the navbar), do it editing the file `src/environments/GlobalVars.ts`.