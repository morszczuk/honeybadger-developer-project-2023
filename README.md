# README

## Summary
This is an implementation of Honeybadger's recruitment task, as defined in here: https://honeybadger.notion.site/honeybadger/Take-home-project-for-Software-Developer-position-2023-fee9be3cd8454e1fb61e53f0172ff2e8

It provides a simple API endpoint, that analyses the provided JSON payload, and if it identifies a Spam Report, it sends a Slack message.
## Installation
### Dockerised development environment
The easiest way to spin off the application in your local machine to test the functionalities is by using Dockerised application, using [rails/docked](https://github.com/rails/docked)

Firstly, ensure you have [docker](https://www.docker.com/products/docker-desktop/) installed on your machine.

Then, perform the following steps:
```
docker volume create ruby-bundle-cache
alias docked='docker run --rm -it -v ${PWD}:/rails -v ruby-bundle-cache:/bundle -p 3000:3000 ghcr.io/rails/cli'

docked bin/setup
docked rails server
```

That's it! The application is now available at `localhost:3000`.

If you want to deploy the application on some server, you can use the same docker image, but perform actions that set up the application on the desired server.
### Slack authorization

#### Create Slack workspace
Create Slack workspace you wish to post the spam report messages to.
#### Give Slack access to your workspace/channel
In your browser, go to:

```
<host>/slack/authorization
```

where `host` is the place where this rails application is deployed (e.g. in development that will be `localhost:3000`).

In the Slack authorization view, select Slack workspace and the channel (pick #general, for testing purposes) you want to post report messages to.

Then, the URL you will be redirected to, will include the `code` param. *(Note: the URL redirection will fail, because it would require knowing the host url before the deployment, to configure the Slack app).*

#### Obtain an access token
Take the value of `code`, and send a request to:
```
GET <host>/slack/access_token?code=<your_code>
```
Then, if the code was correct, the response should include the access token. Save it - it will be handy to send spam report requests!

#### Add bot to your Slack channel
The last step is to add the App to the channel you want to post to. For testing purposes, please choose #general.

Go to the channel, click settings (little arrow next to the name of the channel) -> Integrations -> Apps -> Add app -> Select the "Slack Integration Test" app

#### All set!
Now, with the `access_token` in hand, you are ready to post to the channel!

## Example usage

To see the endpoint in work, perform the following requests using curl, replacing values of:
- <host> - place where the app is deployed
- <slack_access_token> - access_token from the Slack authorization step

### When Report is Spam
Request:
```
curl -X POST <host>/api/v1/report_spam_analysis -H "Content-Type: application/json" -d '{"slack": { "access_token": <slack_access_token> },"report":{ "RecordType": "Bounce", "Type": "SpamNotification", "TypeCode": "512", "Name": "Spam notification", "Tag": "", "MessageStream": "outbound", "Description": "The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.", "Email": "zaphod@example.com", "From": "notifications@honeybadger.io", "BouncedAt": "2023-02-27T21:41:30Z" }}'
```

Expected Response:
```json
{"is_spam":true}
```

### When Report is Not Spam
Request:
```
curl -X POST <host>/api/v1/report_spam_analysis -H "Content-Type: application/json" -d '{"slack": { "access_token": <slack_access_token> },"report":{ "RecordType": "Bounce", "MessageStream": "outbound", "Type": "HardBounce", "TypeCode": 1, "Name": "Hard bounce", "Tag": "Test", "Description": "The server was unable to deliver your message (ex: unknown user, mailbox not found).", "Email": "arthur@example.com", "From": "notifications@honeybadger.io", "BouncedAt": "2019-11-05T16:33:54.9070259Z" }}'
curl -X POST localhost:3000/api/v1/report_spam_analysis -H "Content-Type: application/json" -d '{"slack": { "access_token": "xoxb-4902118330951-4916578303299-BNgsTDCsgvgxZe3wxLrNU5K6" },"report":{ "RecordType": "Bounce", "MessageStream": "outbound", "Type": "HardBounce", "TypeCode": 1, "Name": "Hard bounce", "Tag": "Test", "Description": "The server was unable to deliver your message (ex: unknown user, mailbox not found).", "Email": "arthur@example.com", "From": "notifications@honeybadger.io", "BouncedAt": "2019-11-05T16:33:54.9070259Z" }}'
```

Expected Response:
```json
{"is_spam":false}
```
