# README

## Deployment
### Slack authorization
In your browser, go to

```
/slack/authorization
```

Select Slack workspace and the channel you want to post report messages to.

Then, the URL you will be redirected to, will include the `code` param. *(Note: the URL redirection will fail, because it would require knowing the host url before the deployment, to configure the Slack app).*

Take the value of `code`, and send a request to:
```
GET /slack/access_token?code=<your_code>
```
Then, if the code was correct, you should receive access token in the response. Save it - it will be handy to send spam report requests!
