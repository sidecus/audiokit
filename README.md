# audiokit

Audio toolkit with python

## Build docker image

```Bash
docker build -t sidecus/audiokit ./ 
```

## Run docker image - mounting data folder

```Bash
docker run -it --rm -v $HOME/audiodata:/data sidecus/audiokit
speex_decode /data/input.speex /data/output.wav
```
