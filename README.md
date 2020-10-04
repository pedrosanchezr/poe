# POE (Planning Online Editor)
Planning Online Editor

Simple FE and BE to execute PDDL problems on SGPlan and Optic (more planners can be added with just a small change)


# Changelog

## [1.0.3] - 2020-10-04
### Added
- (FE) Added fullscreen mode on editors

### Changed
- (FE) Fixed deployment scripts in order to generate Compodoc before build so it get's packaged into the distribution
- (FE) Taking app version from package.json to avoid misalignments between GlobalVars and package.json
- (BE) Renamed the input models and other minor changes


### Known issues / Tech debt
- (FE + BE) Check why some extra quotes gets to the console, fix it and remove the workaround to trim them
- (BE) Swagger documentation is being deployed only on HTTP, seems to be a known error/config issue of Flask-Restplus

## [1.0.2] - 2020-10-03
### Added
- (FE) Added sample logos and icon simplifying how to change them and add any license of the new logos
  - App logo (shown on navbar) = /src/app/assets/logo.png
  - App icon = /src/favicon.ico
  - License to be displayed in "About -> Attributions" = /src/app/assets/logo-license.ts (edit the content if the logo is changed)
- (FE) Allowing to change the APP display name
  - Modify /src/environments/global_vars.ts if you need to modify the display name
- (FE) Added an alert to the user when an example is going to overwrite the content of some editor
- (FE) Added gripper example from UAH class materials
- (FE) Added note to blocksworld example as it's not implementing (hand-empty) check
- (FE) Added compodoc to autogenerate documentation
- (FE) Added link to compodoc documentation under "About"
- (BE) Added swagger doc to API
- (FE) Added link to swagger documentation under "About"


### Changed
- (FE) Changed the event that expands the "Examples" submenu, from hover to click. (Reason: hover is not touch screens friendly)
- (FE) Moved Examples definition to a config to allow adding/removing examples in a simplified way
  - Go to /src/app/examples/
  - Edit _config.ts following the instructions of the documentation
- (BE) Refactor to use FlaskRestplus

## [1.0.1] - 2020-09-27
### Added
- (FE) Created GlobalVars file on "environments" to allow change global config non-environment dependant. For now, only app version.
  - TO DO: Take version from package.json
- (FE) Added import/export options to the editor
- (FE) Allow theme selection
  
### Changed
- (BE) Refactor BE code to improve the structure and simplify its extension
- (FE) Added API BASE_URL to environment variables and modified the code to use it instead of the hardcoded parameter
- (FE) Fixed double-binding error between editors and editor-screen
- (FE) Minor changes on how it's deployed to Heroku
- (FE) Minor UI updates to show the last planner executed and block "RUN" button while waiting for response...

## [1.0] - 2020-06-06
### Added
- First "PROD" version including SGPlan and Optic planners, sintax highlighting and plain output
- Basic BE to execute the tasks