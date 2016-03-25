cd ~
wget https://www.dropbox.com/s/1ohubmhtgvo3i3v/jai-1_1_3-lib-linux-amd64-jdk.bin?dl=0 -O jai-1_1_3-lib-linux-amd64-jdk.bin
cp jai-1_1_3-lib-linux-amd64-jdk.bin /usr/lib/jvm/java-8-oracle/
cd /usr/lib/jvm/java-8-oracle/
sh ./jai-1_1_3-lib-linux-amd64-jdk.bin >/dev/null < <(echo y) >/dev/null < <(echo y)
cd ~

#cd ~
wget https://www.dropbox.com/s/llk3pzsrbt7fu4z/jai_imageio-1_1-lib-linux-amd64-jdk.bin?dl=0 -O jai_imageio-1_1-lib-linux-amd64-jdk.bin
sed s/+215/-n+215/ jai_imageio-1_1-lib-linux-amd64-jdk.bin > jai_imageio-1_1-lib-linux-amd64-jdk-fixed.bin
cp jai_imageio-1_1-lib-linux-amd64-jdk-fixed.bin /usr/lib/jvm/java-8-oracle/
cd /usr/lib/jvm/java-8-oracle/
_POSIX2_VERSION=199209 sh ./jai_imageio-1_1-lib-linux-amd64-jdk-fixed.bin >/dev/null < <(echo y) >/dev/null < <(echo y)
cd ~
