Prerequisites
Before you begin, make sure you have the following:

A Github account.
A SonarQube account or an instance of SonarQube running on your local machine or on a remote server.
Access to the repository you want to integrate SonarQube with.
A GitHub App.
GitHub App Permissions.

Steps To Follow
Setup SonarQube

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