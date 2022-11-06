# rn-container

## Motivasi
Baca [Membuat Docker Image Untuk Aplikasi React Native](https://lanjutkoding.com/membuat-docker-image-untuk-aplikasi-react-native)

## Docker on your local machine
### Build
```bash
docker build -qt allcaresquad/rn-container:{version_tag} -f Dockerfile .
```

### Create & start container
```bash
docker run -it allcaresquad/rn-container:{version_tag} /bin/sh
```
