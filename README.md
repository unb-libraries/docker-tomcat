# unblibraries/tomcat:7.x
Docker image : Provides a simple Non-SSL Tomcat instance using Tomcat Native libs. It would be best to extend this instead of 
mounting a WAR into the webapps dir directly.

## Usage
```
docker run --rm \
    --name tomcat7 \
    unblibraries/tomcat:7
```

## License
- Tomcat Docker is licensed under the MIT License:
  - http://opensource.org/licenses/mit-license.html
- Attribution is not required, but much appreciated:
  - `Tomcat Docker by Unb Libraries`
