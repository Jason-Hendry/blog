+++
date = "2015-11-30T12:05:53+11:00"
draft = false
title = "Symfony Dockers Dev Staging Test and Production Enviroments"

+++
One of the key benefits of Using Docker containers is to have a common enviroment throughout the development process. 
However due to the enviroment configurations available in symfony the application can still run differently. 
For Example if you have meta-data caching enabled in production but not in testing, you may not notice missing modules until deployment.
I'm currently working on ways to mitigate this.

## Options 1 - Run everything in a single enviroment mode like "Prod"

Pros: 
- See almost identical setup to prod
- Less likelyhood of missing a required module
- Easy to configure

Cons:
- Logging and debuging is disabled or less verbose
- Symfony only loads generator bundle in dev (by default)

## Run tests in "Prod"


