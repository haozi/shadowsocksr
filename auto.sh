#!/bin/bash
sudo yum install -y unzip wget
cd ~
wget https://github.com/haozi/shadowsocksr/archive/manyuser.zip
unzip manyuser.zip
rm manyuser.zip
mv shadowsocksr-manyuser shadowsocksr
cd ~/shadowsocksr
sh ./initcfg.sh
rm user-config.json
wget https://raw.githubusercontent.com/haozi/shadowsocksr/sh/user-config.json

echo "sudo /bin/bash /home/ec2-user/shadowsocksr/shadowsocks/logrun.sh" | sudo tee -a /etc/rc.d/rc.local
sudo chmod +x /etc/rc.d/rc.local

# 开启 fast-open
echo 3 | sudo tee /proc/sys/net/ipv4/tcp_fastopen

# 安装 bbr
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
sudo yum -y --enablerepo=elrepo-kernel install kernel-ml
sudo grub2-set-default 0

echo 'net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

sudo reboot
