FROM kivy/buildozer:latest
# See https://github.com/kivy/buildozer/blob/master/Dockerfile

# Buildozer will be installed in entrypoint.py
# This is needed to install version specified by user
RUN pip3 uninstall -y buildozer

# Update Cython as Buildozer now requires it to build successfully
RUN pip install --upgrade Cython==0.29.33 virtualenv

# Get the latest JDK version as Buildozer requires the latest version to build the APK
RUN sudo apt-get update && \
    sudo apt-get install -y software-properties-common && \
    sudo rm -rf /var/lib/apt/lists/*
RUN sudo add-apt-repository ppa:openjdk-r/ppa
RUN sudo apt update
RUN sudo apt-get -y install openjdk-17-jdk
# RUN sudo apt-get -y install python3-pip autoconf libtool pkg-config zlibig-dev libncurses5-dev libncursesw5-dev libtinfo5 cmake libffi-dev libssl-dev

# Remove a lot of warnings
# sudo: setrlimit(RLIMIT_CORE): Operation not permitted
# See https://github.com/sudo-project/sudo/issues/42
RUN echo "Set disable_coredump false" | sudo tee -a /etc/sudo.conf > /dev/null

# By default Python buffers output and you see prints after execution
# Set env variable to disable this behavior
ENV PYTHONUNBUFFERED=1

COPY entrypoint.py /action/entrypoint.py
ENTRYPOINT ["/action/entrypoint.py"]
