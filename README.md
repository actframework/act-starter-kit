# Act.Framework Starter Kit
Tooling for Setting Up Act.Framework development environment and projects on your local development machine

## Getting Started for Beginners
### Step 1
Open up a shell and clone the project to a local directory

```
git clone https://github.com/actframework/act-starter-kit.git ~/act-starter-kit
```

### Step 2
Start the starter-kit in interactive mode. 

```
cd ~/act-starter-kit
./act-new.sh
```

### Step 3
\#Win

## Using the Installer
The installer is a simple script that will check all the directories and commands are in their proper place, and then add the *act-new.sh* command to the path for your shell. You do not need to use this installer to use act-new.sh - it's there to make life a little easier for you.

To use the installer (based on the above getting started instructions):

```
cd ~/act-starter-kit
./installer.sh
```

## Using Act.Framework on Windows
We recommend using the awesome [Babun](http://babun.github.io/) as your command-line environment. 

We have successfully developed multiple Act.Framework projects that used Node.JS, MongoDB and Act.Framework on Java 7 and Java 8 with Babun as the shell environment. 

In fact, we were able to have heterogenious environments between Mac, Linux and Windows developers - that is, nobody had to modify anything within their code or configuration to check out code developed by a Mac or Linux user when on Windows. Sweet!

This starter kit should also run on [Babun](http://babun.github.io/) without modification. You may need to install curl as follows since that is not installed by default:

```
pact install curl
```



## Detailed Usage
This little script will create everything you need to get an Act.Framework project set up so you can start writing code. The idea is that there are some basic conventions we agree to use with the structure of projects when using Act.Framework - and this script sets all that up for you without you needing to know everything beforehand.

The Node.JS support is designed to allow Act.Framework to be used for modern web development easily. All you need to do is turn on Node.JS support when you set up a project and the script will set up everything you need to start making a web application with a full Javascript build pipeline as well as Act - all in one. We started using this convention when we developed the Act.Framework website and it worked so well, we have made it a defacto standard.

Command Line Usage:
```
act-new.sh [--node --rythm] [-v=<act version>]  -p=<full-project-path> -n=<project name> -o=<organisation/package name>
```

### What the switches do:
```
--version=<act version>
```
This is an optional parameter. It will set the version of Act.Framework being called from Maven. If you leave it blank, the script will query Maven repo to get the latest version and use that explicitly.


```
--node
```
Insert Node.JS compatibility and build pipeline


```
--rythm
```
Insert Rythm template directory structure and configuration files (and placeholders)

```
-? or --help 
```
You're reading this...

EXAMPLE:

```
act-new.sh --node --rythm -p=~/development/hello-world -n=hello-world -o=com.mycompany.examples
```
## Interactive Mode
If you don't use any command line switches when calling the *act-new.sh* script, you will get the interactive mode to walk you through the setup. 

## Overview of the Directory Structures

### pom.xml
```
pom.xml
```
The *pom file* is used by Maven to pull down all the Act.Framework and other Java dependencies. This is the file you need to add your Java library references to.

### Running the Application Server

```
run_dev
run_prod
```
These commands start the Act.Framework application server. The application server will use *stdout* to put all the output of the server to the console.

When Act.Framework starts up, you will see something like this:

```
  _   _   _____   _       _        ___
 | | | | | ____| | |     | |      / _ \
 | |_| | |  _|   | |     | |     | | | |
 |  _  | | |___  | |___  | |___  | |_| |
 |_| |_| |_____| |_____| |_____|  \___/

    powered by ActFramework R1.3.3-42cbd

 version: 1.0.0
scan pkg: com.pixolut.examples.hello
base dir: /Users/cinj/Development/test-act-startup
     pid: 67073
 profile: dev
    mode: DEV

     zen: Namespaces are one honking great idea -- let's do more of those!

21:34:14.279 [main] INFO  a.Act - loading application(s) ...
21:34:14.303 [main] INFO  a.Act - App starting ....
21:34:14.510 [main] WARN  a.c.AppConfig - Application secret key not set! You are in the dangerous zone!!!
21:34:14.560 [main] WARN  a.a.DbServiceManager - DB service not initialized: No DB plugin found
21:34:15.977 [main] WARN  a.m.MailerConfig - smtp host configuration not found, will use mock smtp to send email
21:34:15.978 [main] WARN  a.c.AppConfig - host is not configured. Use localhost as hostname
21:34:16.471 [main] INFO  a.Act - App[hello] loaded in 2168ms
21:34:16.527 [main] INFO  o.xnio - XNIO version 3.3.6.Final
21:34:16.602 [main] INFO  o.x.nio - XNIO NIO Implementation Version 3.3.6.Final
21:34:17.153 [main] INFO  a.Act - network client hooked on port: 5460
21:34:17.158 [main] INFO  a.Act - CLI server started on port: 5461
21:34:17.163 [main] INFO  a.Act - it takes 5414ms to start the app
```

Notice that there is a network client port and a CLI server port. Once the application is up and running by typing a command, you can point a web browser to the network client port (Default is 5460) and see your web application running. 

You can also telnet on your local machine to the CLI Console port (port 5461) and control the application server from there. You can find the CLI is useful for a couple of important things: 

* First, it is useful for controlling the application server itself, you can start and stop, manage memory, query application routes and set up performance counters
* Second, you can make your own console commands (things you would normally need to make an admin website for - like creating new accounts or other things that only administrators would ever do - these can be done in a fraction of the time using the CLI

### Setup Node.JS 
```
setup_project
```
You can run the *setup_project* script to download all the Node.JS dependencies using NPM and also the Java dependencies using Maven with this one command. 

The idea is that I can download the source code from a GIT repo and run one command and know that all my dependencies have been satisfied as long as I have the following installed:

* Maven
* Node.JS
* NPM
* Gulp (installed in global mode)

*Side note:* to install Gulp, as below:
```
npm install --global gulp
npm link gulp
```
Note that you will also have the following file created for you when you install Node.JS support:

```
gulpfile.js
package.json
```
Here is the general rules for maintaining these files:

* You should only need to update your *package.json* file when you add a new dependency to your project from NPM - for example, using Bootstrap or JQuery. You can see in the example *package.json* we have those in there for you already.
* You should only need to update the *gulpfile.js* when you add a new dependency in your *package.json* - you need to find the actual files you need to serve up (.css and .js files) and if they are already minified then, put references to them from the *node_modules* directory into the appropriate section of that gulpfile.
* By doing this, you are setting up projects to configure from NPM and be able to be optimized and minified (if required) and put into the correct place within the Act.Framework application directory structure.
* Put your own JS, CSS or LESS code into the *js.src* *css.src* and *less.src* directories and anything in those places will be compiled and optimised. No need to touch the *gulpfile.js*

### Live Reload Between Front and Back End
You can have two shell sessions open, you can execute *run_dev* in one, and the execute *gulp watch* in the other. This allows true end-to-end live reload of CSS, JS, LESS and backend Java and Rythm templates. 

Seriously, this development experience is like riding unicorn rainbows.

---

# Other Documentation

(The following sections need to be added for completeness.)
## Setting Up routes.conf
todo

## Setting up app.properties
todo

## Setting up messages.properties
todo



 
