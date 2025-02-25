FROM ubuntu:20.04
LABEL org.opencontainers.image.description "Prebuild container setup for building react-native apk or aab"
LABEL org.opencontainers.image.authors skull.saders18@gmail.com
# set ARG to bypass dialog error \
# "debconf: unable to initialize frontend: Dialog debconf: (TERM is not set, so the dialog frontend is not usable.) debconf: falling back to frontend: Readline Configuring tzdata" \
# when installing git
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Asia/Jakarta
ARG NODE_VERSION=16.x
ARG SDK_VERSION=7583922
ARG NDK_VERSION=23.1.7779620
ARG CMAKE_VERSION=3.22.1
ARG ANDROID_VERSION=android-33
ARG ANDROID_BUILD_TOOLS_VERSION=33.0.0

RUN apt update && apt install -y curl && \
curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && \
apt -y install gcc g++ make && \
apt install -y nodejs openjdk-11-jre-headless python3 ruby-full

RUN apt install -y expect git openjdk-11-jdk-headless wget zip unzip vim && \
wget https://dl.google.com/android/repository/commandlinetools-linux-${SDK_VERSION}_latest.zip
RUN mkdir -p Android/Sdk && unzip commandlinetools-linux-${SDK_VERSION}_latest.zip -d Android/Sdk/cmdline-tools && \
mv Android/Sdk/cmdline-tools/cmdline-tools Android/Sdk/cmdline-tools/latest

ENV ANDROID_HOME="$HOME/Android/Sdk"
ENV PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest"
ENV PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
ENV PATH="$PATH:$ANDROID_HOME/platform-tools"

RUN yes | sdkmanager --sdk_root=${ANDROID_HOME} "tools"
RUN sdkmanager "platform-tools" "platforms;android-30" "platforms;${ANDROID_VERSION}" "build-tools;30.0.3" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"
# If you use react-native-reanimated or react-native-mmkv-storage then install ndk & cmake
RUN sdkmanager --install "ndk;${NDK_VERSION}"
RUN sdkmanager --install "cmake;${CMAKE_VERSION}"
RUN sdkmanager --licenses
RUN gem install fastlane -NV
RUN corepack enable
RUN yarn global --silent --no-progress add appcenter-cli
# RUN yarn global --silent --no-progress add firebase-tools@11.19.0

CMD ["/bin/sh"]
