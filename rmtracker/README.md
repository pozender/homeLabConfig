## Building docker image
``docker build -t autoremovetracker:latest``

## Exporting image
``docker save <image Name> -o ./outputFile.tar``

## Importing image
``docker load -i <outputFile>``

## Docker command to run the container
``docker run -d --name=rmtracker --network=host --restart=always --env-file=/home/pozender/rmtracker/rmtracker.env autoremovetracker:latest``
