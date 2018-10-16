#!/bin/bash
SSLVerSion=1.0.2o

SSHVerSion=7.7p1

OUTok=/tmp/okfile

OUTerror=/tmp/errorfile

mkdir -p /tmp/159080113

cd /tmp/159080113

IpS=serverip

wget http://$IpS/tools/tar/openssl-${SSLVerSion}.tar.gz

wget http://$IpS/tools/tar/openssh-${SSHVerSion}.tar.gz

wget http://$IpS/tools/tar/zlib-1.2.11.tar.gz

wget http://$IpS/tools/openssh_cp.sh

wget http://$IpS/tools/openssl_cp.sh

tar -xvf zlib-1.2.11.tar.gz > /dev/null 2>1

cd zlib-1.2.11

echo "################Zlibconfigre################" >> ${OUTok}
echo "################Zlibconfigre################" >> ${OUTerror}
./configure >> ${OUTok} 2>> ${OUTerror}
if [ $? -ne 0 ]
then
        echo -e "\033[31m ##########Zlibconfig_error##########  \033[0m"
        exit
fi

echo "################Zlibmake################" >> ${OUTok}
echo "################Zlibmake################" >> ${OUTerror}
make  >> ${OUTok} 2>> ${OUTerror}
if [ $? -ne 0 ]
then
        echo -e "\033[31m ##########Zlibmake_error##########  \033[0m"
        exit
fi


echo "################Zlibmakeinstall################" >> ${OUTok}
echo "################Zlibmakeinstall################" >> ${OUTerror}
make install  >> ${OUTok} 2>> ${OUTerror}
if [ $? -ne 0 ]
then
        echo -e "\033[31m ##########Zlibmakeinstall_error##########  \033[0m"
        exit
fi

sh /tmp/159080113/openssl_cp.sh
if [ $? -ne 0 ]
then
        echo -e "\033[31m ##########OPENSSL_error##########  \033[0m"
        exit
fi

PAM6=1.1.1-17

cat /etc/redhat-release  | grep "release 6."  >> ${OUTok} 2>> ${OUTerror}
if [ $? -eq 0 ]
then
	rpm -qa | grep pam-1.1.1.*.el6.x86_64 >> ${OUTok} 2>> ${OUTerror}
	if [ $? -eq 0 ]
	then
		rpm -qa | grep pam-$PAM6.el6.x86_64 >> ${OUTok} 2>> ${OUTerror}
		if [ $? -ne 0 ]
		then
			rpm -Uvh http://$IpS/tools/tar/pam-$PAM6.el6.x86_64.rpm
		fi
		rpm -qa | grep pam-devel-1.1.1.*.el6.x86_64 >> ${OUTok} 2>> ${OUTerror}
		if [ $? -eq 0 ]
		then
			rpm -qa | grep pam-devel-$PAM6.el6.x86_64 >> ${OUTok} 2>> ${OUTerror}
			if [ $? -ne 0 ]
			then
				rpm -Uvh http://$IpS/tools/tar/pam-devel-$PAM6.el6.x86_64.rpm
			fi
		else
			rpm -ivh http://$IpS/tools/tar/pam-devel-$PAM6.el6.x86_64.rpm
		fi
	else
		rpm -ivh http://$IpS/tools/tar/pam-$PAM6.el6.x86_64.rpm
		rpm -ivh http://$IpS/tools/tar/pam-devel-$PAM6.el6.x86_64.rpm
	fi
fi

sh /tmp/159080113/openssh_cp.sh
if [ $? -ne 0 ]
then
        echo -e "\033[31m ##########OPENSSH_error##########  \033[0m"
        exit
fi

rm -f /tmp/159080113/openssl-${SSLVerSion}.tar.gz
rm -f /tmp/159080113/openssh-${SSHVerSion}.tar.gz
rm -f /tmp/159080113/openssh_cp.sh
rm -f /tmp/159080113/openssl_cp.sh
