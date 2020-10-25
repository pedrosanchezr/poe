# POE (Planning Online Editor)
Planning Online Editor
<poe-fe.herokuapp.com>

Web-based development environment for PDDL
It's aimed to be used by Automatted planning students to compare the results of different planners without having to compile the planners, use a Linux machine to run them, setup your environment, etc.

In future releases I plan to add more features to simplify the work, make easier to undertand how it works and add content to learn the different versions of PDDL.

# Changelog
## [1.0.5] - 2020-10-23
### Added
- License file for the repository

### Changed
- Modified license and attribute pages on the site to reflect the new conditions
  
### Known issues / Tech debt
- (BE) Swagger documentation is being deployed only on HTTP, seems to be a known error/config issue of Flask-Restplus

## [1.0.4] - 2020-10-05
### Added
- Nothing

### Changed
- (FE) Bugfix for extra quotes on output
- (FE) Bugfix issues related to duplicate controls for smartphones layout
- (FE) Minor fixes for better visualization on different resolutions

## [1.0.3] - 2020-10-04
### Added
- (FE) Added fullscreen mode on editors
- (FE) Added options to increase/decrase fontsize of editors
- (FE) Added button to switch between one editor or the other on small screens (if screen is to small, it hides always one of the editors)

### Changed
- (FE) Fixed deployment scripts in order to generate Compodoc before build so it get's packaged into the distribution
- (FE) Taking app version from package.json to avoid misalignments between GlobalVars and package.json
- (BE) Renamed the input models and other minor changes

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