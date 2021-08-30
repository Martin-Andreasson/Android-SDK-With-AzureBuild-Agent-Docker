# Android-SDK-Docker-Image

This image runs an Azure Agent with Android SDK and Java JDK 11 for building Android applications.
Please provide the following enviroment variables when running this image.

    AZP_URL=https://dev.azure.com/yourorg 
    AZP_TOKEN=$yourtoken
    AZP_AGENT_NAME=Name 
    AZP_POOL=Pool

Example:
```docker
docker run --name name --storage-opt size=50GB -d -e AZP_URL=https://dev.azure.com/yourorg -e AZP_TOKEN=$yourtoken -e AZP_AGENT_NAME=name -e AZP_POOL="Linux" 850aa2kasde0680a
```

