# TODO
- [x] the commit sha parameter for the ci repo
- [x] install rebuild plugin
- [x] omnibus build names should include the name of the build (e.g. ios-build), commit sha of the app repo, and a PR build number if present, also CI branch if other than main
- [x] quiet period set to 0
- [x] pipeline durability set to performance
- [x] should we move the ci trigger job to the ci repo?
- [x] move changes detection to the ci-cli tool from trigger job
- [x] write tests for change detection
- [x] move checking collabolators to the ci-cli tool from trigger job
- [x] move publishing commit statues for skipped checks to the ci-cli from trigger job
- [x] remove duplication in the trigger job
- [x] change the tigger pipeline to wait for the jobs
- [x] builds should have names for the trigger pipeline, e.g. #2 <commit sha> <PR#34> [ci:<branch>]
- [x] use consistent naming for parameters, e.g. use CHANGE_ID instead of PR_NUMBER, rename parameters where necessary
- [x] ci-cli: load secrets from env variables, do not pass as arguments on the cli, e.g. github token
- [x] the ios and android build jobs should trigger the deploy jobs when they finish: this should probably trigger the omnibus job with the right parameters, to follow what we do in the trigger job
- [x] can we remove this block: Build & Quality and leave the child blocks in place? it looks confusing
- [x] create scripts in the root repo to clone the repositories and start jenkins and tell the user to open jenkins in browser and open PR to the repo
- [x] rename repositories: jenkinsfiles-test -> jenkins-setup, jenkinsfiles-test-app -> mobile-app, jenkinsfiles-test-app-ci -> mobile-app-ci, jenkins (root folder) -> jenkins-for-mobile-app
- [x] rename pipeline to Mobile App
- [x] define a test alpha pipeline
- [x] define a test production pipeline
- [x] next js app for displaying the status of commits on main and all of the PRs
- [x] next js app for displaying the alpha and production pipeline
- [x] add dummy build scripts to the mobile-app repo for ios/android build, lint, unit tests, ui tests, these scripts should be used by ./ci-cli to run the corresponding steps
- [x] add a new cli script called ./fast, that can be used by developers to run CI checks locally, e.g. ./fast ready (run all the checks in series - except alpha and production builds, and no deploy step), ./fast ios build, ./fast ios alpha-build, etc. - print with nice colours
- [x] what would be the integration with automation repo?
- [x] what would be the integration with local dev commands?
- [x] what to do with submodules that have the build scripts?

- [ ] run the app trigger job automatically with the branch from the PR to the CI repository as a parameter as part of the CI repo Jenkinsfile (this is so 
that we can test changes to the CI repository before merging to main)

- [ ] it should be possible to specify as a parameter branch or PR number in the trigger job
- [ ] can macos cloud plugin be configured on multiple jenkinses to share the same controller?