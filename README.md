# unblibraries/tomcat:7.x
Docker image : Provides a simple Non-SSL Tomcat instance that leverages the
Tomcat Native libs.

This image is best suited to be used through extension (e.g. [unblibraries/openwayback](https://github.com/unb-libraries/docker-openwayback))
instead of using docker volume statements to mount WAR files into the webapps
path.

## Usage
```
docker run --rm \
    --name tomcat7 \
    unblibraries/tomcat:7.x
```

## Runtime/Environment Variables
* `JAVA_OPTS` - (Optional) Options to pass to the java runtime for executing
Tomcat. Defaults to "-Djava.awt.headless=true -Xmx128M".

## License
- Tomcat Docker is licensed under the MIT License:
  - [http://opensource.org/licenses/mit-license.html](http://opensource.org/licenses/mit-license.html)
- Attribution is not required, but much appreciated:
  - `Tomcat Docker by UNB Libraries`
