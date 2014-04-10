# CHANGELOG for radioedit

This file is used to list changes made in each version of radioedit.

## 0.1.0:

* Initial release of radioedit

## 0.1.1

* @TODO

## 1.0.0

* @TODO

## 1.2.0

* Han Release
* Introduces 3 app stack: api, auth, and script
* Split attribute files up per app
* Split up application deployment into separate recipes
* Introduces 2 LWRPs radioedit_unicorn and radioedit_node used as application deployment abstraction layer

## 1.2.1

* recipe[radioedit::binstore-backup] installs shell script to create a local tarball of the binstore directory as well as rsync it to the backup server

## 1.2.2

* recipe[radioedit::app-restart-script] installs a shell script in /usr/local/bin to restart the applications within the radioedit stack

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
