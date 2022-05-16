# Autoscale
An example of time-based autoscaling on Aptible.

## Customization and deployment

1. Update the crontab to match your own personal scaling needs.
2. [Maybe] Update `notify_failure` in `scale` to notify your desired destination 
   (e.g. OpsGenie, PagerDuty, Slack).
3. Build, publish, and deploy the image. Be sure to set 
   `APTIBLE_USERNAME` and `APTIBLE_PASSWORD` as environment variables when deploying.
4. Enjoy.

## Required environment variables

* `APTIBLE_USERNAME`
* `APTIBLE_PASSWORD`

## Future TODOs

* Building the crontab from a YML or JSON file.
* Integrating with something like [Dead Man's Snitch](https://deadmanssnitch.com/)
  for an "is this even running?" check.
* Running `aptible login` once for every scaling operation might hit rate limiting if there's several
  scaling operations happening concurrently. This should only log in if there's not already a
  valid token available.
* Notification examples/options.