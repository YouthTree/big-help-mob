# Big Help Mob - Community Powered Volunteering Flash Mobs

Big Help Mob is Youth Tree's latest project currently in development. The idea is simple: Regularly get together 100+ young people from all across the metro area in a big mob and do something useful for a local not-for-profit (tree-planting, renovating homeless shelters etc)... and then celebrate with enormous, ludicrous flash-mobs (100 people looking up at the sky in the CBD for no apparent reason... that sort of thing). (From the original Big Help Mob teaser / intro site)

## About this Application

This app serves as registration and event management for each Big Help Mob event. The app is written on Rails 3 and the "Youth Tree Stack" - a common set of technology (haml, sass + compass, coffeescript + barista and a few other things).

The application uses [git flow](), with the `master` branch being used for the current stable
and `development` being used for the next release. As such, deploying to production should
always use `master` whilst deploying to staging shall always use `development`.

## Deploying

On the Big Help Mob team? Deployment should be a simple matter of:

1. `cap production deploy` - Deploy from `master` to the production server, http://bighelpmob.org/
2. `cap deploy` - Deploy from `development` to the staging server, http://staging.bighelpmob.org/

For more access details, please contact the other members of the team.

## Getting Started

TBD: Write these instructions

## Syncing the Database

Want to work with a copy of production / staging data on your local box?
Assuming you have access the production server, you can do so by running
`cap [environment] sync:down` where environment is `staging` or `production`.

If no environment is passed, the app defaults to `staging`. On import,
To prevent accidental mass emails, all users emails are reset to `example+n@example.com`.

To push your local database to `staging`, you simply do: `cap staging sync:up`.

Note, you can combine these to clone `production` to `staging` with the cleaned
data set by running `./script/sync-db`.

## Contributing

We encourage all community contributions. Keeping this in mind, please follow these general guidelines when contributing:

* Fork the project
* Create a topic branch for what you’re working on (git checkout -b awesome_feature)
* Commit away, push that up (git push your\_remote awesome\_feature)
* Create a new GitHub Issue with the commit, asking for review. Alternatively, send a pull request with details of what you added.
* Once it’s accepted, if you want access to the core repository feel free to ask! Otherwise, you can continue to hack away in your own fork.

Other than that, our guidelines very closely match the GemCutter guidelines [here](http://wiki.github.com/qrush/gemcutter/contribution-guidelines).

(Thanks to [GemCutter](http://wiki.github.com/qrush/gemcutter/) for the contribution guide)

## License

All code is licensed under the New BSD License and is copyright YouthTree. Please keep this
in mind when contributing.