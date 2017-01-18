#!/usr/bin/env bash -e

# gotten from http://www.pyimagesearch.com/2016/04/18/install-guide-raspberry-pi-3-raspbian-jessie-opencv-3/

apt-get purge wolfram-engine
apt-get update
apt-get upgrade
apt-get -y install build-essential cmake pkg-config
apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
apt-get -y install libxvidcore-dev libx264-dev
apt-get -y install libgtk2.0-dev
apt-get -y install libatlas-base-dev gfortran
apt-get -y install python2.7-dev python3-dev

cd ~
wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.2.0.zip
unzip opencv.zip
wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.2.0.zip
unzip opencv_contrib.zip

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install virtualenv virtualenvwrapper
rm -rf ~/.cache/pip

echo -e "\n# virtualenv and virtualenvwrapper" >> ~/.profile
echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.profile
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.profile
source ~/.profile

mkvirtualenv cv -p python3

workon cv

pip install numpy

cd ~/opencv-3.2.0/
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.2.0/modules \
    -D BUILD_EXAMPLES=ON ..

make -j4
make clean
make
make install
ldconfig

ls -l /usr/local/lib/python3.4/site-packages/

cd /usr/local/lib/python3.4/site-packages/
mv cv2.cpython-34m.so cv2.so
cd ~/.virtualenvs/cv/lib/python3.4/site-packages/
ln -s /usr/local/lib/python3.4/site-packages/cv2.so cv2.so

cd ~
# rm -rf opencv-3.2.0 opencv_contrib-3.2.0
