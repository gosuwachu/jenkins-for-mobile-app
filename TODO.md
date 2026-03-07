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

- [ ] make ios and android build trigger the deploy job at the end

- [ ] what would be the integration with release-automation repo?
- [ ] what would be the integration with quick?
- [ ] what to do with submodules that have the build scripts?

- [ ] run the app trigger job automatically with the branch from the PR to the CI repository as a parameter as part of the CI repo Jenkinsfile (this is so 
that we can test changes to the CI repository)

- [ ] next js app for displaying the status of commits on main and all of the PRs
- [ ] next js app for displaying the alpha and release pipeline

- [ ] define a test alpha pipeline

- [ ] it should be possible to specify as a parameter branch or PR number in the trigger job

- [ ] can anka plugin be configured on multiple jenkinses to share the same controller?