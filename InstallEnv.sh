#! /usr/bin/bash

###############################################################################
#
#This script upgrades your DragonBoard410c's environment to run the examples of 
#the IBM-iot-starter-kit.
#
###############################################################################


#Install prerequisites:
#-------------------------------------------------------------------------------
sudo apt-get install -y git build-essential autoconf libtool swig3.0 \
python-dev nodejs-dev cmake pkg-config libpcre3-dev
sudo apt-get clean

#Create Project directory:
#-------------------------------------------------------------------------------
mkdir ~/Projects

#Install Arrows ibm-iot-starter-kit repository:
#-------------------------------------------------------------------------------
cd ~/Projects
git clone https://github.com/ArrowElectronics/ibm-iot-starter-kit 


#Install IBM-MQTT-Client:
#-------------------------------------------------------------------------------
cd ~/Projects
git clone https://github.com/ibm-messaging/iotf-embeddedc.git


#Install MRAA library:
#-------------------------------------------------------------------------------
#mraa is a development library that provides access to the kernels i2c, gpio 
#and spi interfaces.

cd ~/Projects
git clone https://github.com/intel-iot-devkit/mraa
cd mraa
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig /usr/local/lib/


#Install UPM library:
#-------------------------------------------------------------------------------
#UPM is an object oriented library of drivers for many Grove I2C devices, such 
#as the Grove RGB backlight LCD module #included in this kit.
#Be patient with this step. UPM takes about 23 minutes to build.
cd ~/Projects
sudo ln -s /usr/bin/swig3.0 /usr/bin/swig
git clone https://github.com/intel-iot-devkit/upm
cd upm
mkdir build
cd build
cmake -DBUILDSWIGNODE=OFF ..
make
sudo make install
sudo ldconfig /usr/local/lib/libupm-*


#Configure the software:
#-------------------------------------------------------------------------------
#The last step is to install some configuration files so that the development 
#tools know which devices to uses. Fetch #the 96boards-tools package and install
#the provided configuration files:
cd ~/Projects
sudo addgroup linaro i2c  # Allow the normal user to perform i2c operations
git clone https://github.com/96boards/96boards-tools
sudo cp 96boards-tools/70-96boards-common.rules /etc/udev/rules.d/

cat | sudo tee /etc/profile.d/96boards-sensors.sh << EOF export JAVA_TOOL_OPTIONS="-Dgnu.io.rxtx.SerialPorts=/dev/tty96B0" export MONITOR_PORT=/dev/tty96B0 export PYTHONPATH="$PYTHONPATH:/usr/local/lib/python2.7/site-packages" EOF
sudo cp /etc/profile.d/96boards-sensors.sh /etc/X11/Xsession.d/96boards-sensors

#Reboot the system:
#-------------------------------------------------------------------------------
#Now reboot the system to pick up all the changes.
sudo reboot