# speexdecode
Docker image to decode Wechat speex files

# Build docker image
```
docker build -t speexdecode ./ 
```

# Run docker image - mounting data folder
```
docker run -it --rm -v $HOME/audiodata:/data speexdecode
speex_decode /data/input.speex /data/output.wav
```
