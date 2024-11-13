Prerequisites
Before you begin, make sure you have the following:

A Github account.
A SonarQube account or an instance of SonarQube running on your local machine or on a remote server.
Access to the repository you want to integrate SonarQube with.
A GitHub App.
GitHub App Permissions.

Steps To Follow
Setup SonarQube
https://medium.com/@s.mehrotrasahil/integrate-sonarqube-in-github-actions-d89eafc7fd69

Navigate to SonarQube in your web browser.
Log in to SonarQube with the admin credentials.
Click on Administrator icon → My Account→ Security → Generate to generate a token for your project. Note down/save this token as it will be needed later(provide details according to your need like token type and Expires in).
3. Create a new project in SonarQube by following below steps:

-> Click the “Create project” button on the SonarQube dashboard.

-> Select GitHub or Manual.

-> If you want to create a new project click on the “Create project” button on the SonarQube dashboard then provide “Project display name” and “Project key” then click “Setup” button.

>You will get a YML file and sonar.projectKey based on your project. Copy this file because we need it later.
Add SonarQube Token And URL Into GitHub Secrets
Navigate to your repository in Github and click the “Settings” tab.
Click “Secrets” in the sidebar.
Click “New secret” and enter SONAR_TOKEN as the name.
Enter the token generated for your SonarQube project
Create one more secret for SONAR_HOST_URL as the name and Enter the URL for your sonarqube dashboard as the value.
Click “Add secret” to save.
Configure Github Actions
Navigate to your repository in Github and click the “Actions” tab.
Click the “New workflow” button and select “Set up a workflow yourself”.
Give your workflow a name and create a new YAML file.
Paste the yml file as we copied before..
Paste the “sonar-project.properties” file.




Yes, you can configure GitHub Actions to only allow a pull request to be merged when all workflow checks (such as CodeQL, Dependabot Updates, Deployment, Python Application tests, and SonarQube analysis) have passed. This can be achieved by setting up branch protection rules in your repository. Here’s how you can do it:

Step-by-Step Guide to Enforce Checks on Pull Requests
Go to Your GitHub Repository Settings:

Navigate to your GitHub repository and go to Settings.
Configure Branch Protection Rules:

In the left sidebar, select Branches.
Under Branch protection rules, click Add rule.
Specify the Branch to Protect:

In the Branch name pattern field, enter the branch you want to protect (e.g., master or main).
Enable Required Status Checks:

Check Require status checks to pass before merging.
In the Status checks that are required field, select each of your workflow actions (e.g., "CodeQL Advanced", "Dependabot Updates", "Deploy to Amazon ECS", "Python application", "SonarQube analysis") as required checks.
This means that all selected checks must pass before the pull request can be merged.
Enable Additional Protection Options (Optional):

You may also enable Require pull request reviews before merging to ensure that each pull request gets a review.
Check Require conversation resolution before merging to ensure all discussions in the pull request are resolved.
Save the Protection Rule:

Click Create or Save changes to enforce the rule.
Result
With this setup, GitHub will prevent the pull request from being merged unless all configured checks (i.e., each workflow in your Actions list) have passed. This enforces quality and ensures that only validated code is merged into your main branch.



Comparing artifacts and dependency caching
Artifacts and caching are similar because they provide the ability to store files on GitHub, but each feature offers different use cases and cannot be used interchangeably.

Use caching when you want to reuse files that don't change often between jobs or workflow runs, such as build dependencies from a package management system.
Use artifacts when you want to save files produced by a job to view after a workflow run has ended, such as built binaries or build logs.

By caching dependencies and other frequently reused files, we can significantly reduce the time our workflows take to run.

key: Required The key created when saving a cache and the key used to search for a cache. It can be any combination of variables, context values, static strings, and functions. 

path: Required The path(s) on the runner to cache or restore. Example for npm dependendencies: path: we specify the cache location (~/.npm) where npm stores the downloaded modules.