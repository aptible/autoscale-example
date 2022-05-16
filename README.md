# Autoscale
An example of time-based autoscaling on Aptible.

## Usage

The core command that triggers scaling is `/opt/app/scale`.
Help should tell you most of what you need to know about using that command:

```bash
# /opt/app/scale --help
usage: scale [-h] --app APP --service SERVICE [--environment ENVIRONMENT] [--container-size CONTAINER_SIZE] [--container-count CONTAINER_COUNT] [--retries RETRIES]

Scale an Aptible App.

options:
  -h, --help            show this help message and exit
  --app APP             The App to be scaled.
  --service SERVICE     The Service to be scaled.
  --environment ENVIRONMENT
                        The Environment containing the App. If left blank, and multiple apps have the same name, scaling will fail.
  --container-size CONTAINER_SIZE
                        The size of containers to scale to in MB. If left blank, the existing size will be used.
  --container-count CONTAINER_COUNT
                        Number of containers to scale to. If left blank, the existing size will be used.
  --retries RETRIES     The number of times to retry when a scaling operation fails. Defaults to 0 (never retry).
```

Once you have an idea of what scaling actions you want to take and when, you can add that to the crontab.
For example, if you want to scale the `cmd` service of your `example` app up to 2 containers every day at 8 AM UTC,
and down to 0 containers at 8 PM UTC, your crontab would look like this:

```bash
0 8 * * * /opt/app/scale --app example --service cmd --container-count 2
0 20 * * * /opt/app/scale --app example --service cmd --container-count 0
```


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

* [Coming soon!] Productionize this. Add typing, testing, linting, example CI/CD etc.
* Building the crontab from a YML or JSON file.
* Integrating with something like [Dead Man's Snitch](https://deadmanssnitch.com/)
  for an "is this even running?" check.
* Running `aptible login` once for every scaling operation might hit rate limiting if there's several
  scaling operations happening concurrently. This should only log in if there's not already a
  valid token available.
* Notification examples/options.
* [Far future] We could probably create consumption-based autoscaling example using a very similar approach.