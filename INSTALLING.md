# Installing the Big Help Mob Application #

Welcome wayward travellers, to the installation guide for the Big Help Mob web app.
It's a fairly simple process to get started, but it assumes you're working on a machine
with:

- Ruby 1.8.7 or higher
- Bundler 0.9 or higher
- Mysql
- Git

## Steps ##

### Step Number 1: Clone this repository. ###

To get started, you'll need to check out a copy of this application. This is as simple
as cd'ing into your parent code directory and doing something similar to:

    $ git clone git://github.com/YouthTree/big-help-mob.git

If you're a collaborator on the repository, you'll instead want to clone from the
repository with push access:

    $ git clone git@github.com:YouthTree/big-help-mob.git

Then you can just cd into the big help mob directory, e.g.:

    $ cd big-help-mob

### Step Number 2: Installing Dependencies ###

Since we use bundler for our dependency management, installing all the requirements (which are
numerous) is simple. Please note that unless you're using something like rvm gemsets, you'll
likely want to execute commands down the line (like `rails s`) by prefixing them with `bundle exec`.

Typically, you can either use:

    $ bundle install

To install them to a default `~/.bundle` directory, but typically (as is supported by the `.gitignore`)
I (@Sutto) use:

    $ bundle install .bundle-cache --disable-shared-gems

Which will install all dependencies to the .bundle-cache directory under rails root.

For future reference, I've aliased `bi` to `bundle install .bundle-cache --disable-shared-gems` and `be` to `bundle exec`,
making it simpler / less typing whenever you have to run these commands.

Please note it's a good idea to run bundle install as above whenever you pull in order to
update dependencies. The first time you run it, it may also take a while (to fetch them and
to clone the git repositories).

### Step Number 3: Configuring the Application ###

The Big Help Mob app uses a simple settings file (as yaml) in `config/settings.yml`. To get started,
you can copy `config/settings.yml.example` to `config/settings.yml` - it is also automatically added
to the `.gitignore` so you don't have to worry about having private information in the settings file.

You'll need to have a rpx now api key if you wish to do anything involving non-internal authentication
an a mailchimp api key for things specific to the mailing lists.

### Step Number 4: Creating the database and loading an initial dataset ###

Now, you'll need to create a development and test database. Please note that `config/database.yml`
*is version controlled*, so don't add passwords etc to it. In the future, we may move it to an example
file like settings but currently it expects a user root with no password.

Please create `bighelpmob_development` and `bighelpmob_test` databases, then run:

    $ rake db:setup

To load the schema and seed some initial data.

If you have access to the production server, you can use:

    $ rake deploy:import

To import a sanitized version of the production data for the website.

### Step Number 5: Starting the application ###

Once all of this is done, using the app should be a matter of typing `rails s` (if you have
rails 3 in your system gems) or `bundle exec rails s` otherwise.

Enjoy! you can not visit the site at [http://localhost:3000/](http://localhost:3000/)

Note you can also log in with the username **admin** and password **bighelpmob** out of the box
