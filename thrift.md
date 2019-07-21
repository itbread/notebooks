# thrift 使用

##编译安装依赖
``` bash
sudo apt-get install libboost-dev libboost-test-dev libboost-program-options-dev libboost-filesystem-dev libboost-thread-dev libevent-dev automake libtool flex bison pkg-config g++ libssl-dev
```

##下载代码
``` bash
git clone https://github.com/apache/thrift
cd thrift
./bootstrap.sh
./configure --without-qt4 --wihout-qt5
make
sudo make install
```