The project in this repository shows an example of:

1. Using [ml-gradle](https://github.com/rjrudin/ml-gradle), a [Gradle](http://gradle.org/) plugin, to deploy a [MarkLogic](http://www.marklogic.com/) REST API application
1. Using ml-gradle and [mlcp](https://docs.marklogic.com/guide/ingestion/content-pump) to ingest and transform a zip file of just under 10k tweets into the REST API database
1. Using the out-of-the-box REST API search interface to search the tweets
1. Using a custom REST API transform to return JSON data for each tweet

Here's how to try it out:

1. You'll need MarkLogic 8+ installed and Java 1.7+ installed (you don't need Gradle though, this project uses the [Gradle wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html))
1. Clone this repository locally
1. ./gradlew mlDeploy import

The above Gradle commands will use ml-gradle to deploy a REST API application on port 8210 (change this in gradle.properties if you already have something on that port), download a zip file of tweets, and ingest and transform those tweets using mlcp. 

Once you've run those commands, you can use any HTTP client to do the following:

1. Go to http://localhost:8210/v1/search?options=tweet-options to search the data (this set of options includes a few facets). The tweet-options search options can be found at src/main/ml-modules/options. 
1. Go to http://localhost:8210/v1/documents?uri=/twitter_1332944530763.xml&transform=to-json to see a JSON representation of an XML tweet document (you can pick any URI you'd like, that's just a sample). The to-json transform can be found at src/main/ml-modules/transforms. 
