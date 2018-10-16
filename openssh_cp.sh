#!/bin/bash

SSLVerSion=1.0.2o

SSHVerSion=7.7p1

SSLPREHOME=/usr/local/openssl-${SSLVerSion}

SSHPREHOME=/usr/local/openssh-${SSHVerSion}

#CONFIG="./configure  --prefix=${SSHPREHOME} --sysconfdir=/etc/ssh --with-md5-passwords --with-pam --with-ssl-dir=${SSLPREHOME} --with-tcp-wrappers"
CONFIG="./configure  --prefix=${SSHPREHOME} --sysconfdir=/etc/ssh --with-md5-passwords --with-pam --with-ssl-dir=${SSLPREHOME} --without-openssl-header-check"

OUTok=/tmp/okfile

OUTerror=/tmp/errorfile

TiME=2018-09-19

TARTFILE=/tmp/159080113


uname -a | grep x86_64 &>/dev/null
if [ $? -eq 0 ]
then
L_iB=/usr/lib64
else
L_iB=/usr/lib
fi

if [ ! -f ${L_iB}/${TiME} ]
then
	mkdir -pv  ${L_iB}/${TiME}
fi



SSHCONFIG_judge(){
if [ $? -ne 0 ]
then
	echo -e "\033[31m ##########SSHconfigure_error##########  \033[0m"
	exit
else
	echo -e "\033[32m####################SSH_configure_ok####################\033[0m"
fi
}


SSHMAKE_judge(){
if [ $? -ne 0 ]
then
	echo -e "\033[31m ##########SSH_make_error##########  \033[0m"
	exit
else
	echo -e "\033[32m####################SSH_make_ok####################\033[0m"
fi
}


SSHMAKEINSTALL_judge(){
if [ $? -ne 0 ]
then
	echo -e "\033[31m ##########SSH_make_install_error##########  \033[0m"
	exit
else
	echo -e "\033[32m####################SSH_make_install_ok####################\033[0m"
fi
}

SSH_CONFIG(){
echo "################SSHconfigre################" >> ${OUTok}
echo "################SSHconfigre################" >> ${OUTerror}
$CONFIG  >> ${OUTok} 2>> ${OUTerror}
SSHCONFIG_judge
}

SSH_make(){
echo "################SSHmake################" >> ${OUTok}
echo "################SSHmake################" >> ${OUTerror}
make  >> ${OUTok} 2>> ${OUTerror}
SSHMAKE_judge
}

SSH_makeinsall(){
echo "################SSHmakeinstall################" >> ${OUTok}
echo "################SSHmakeinstall################" >> ${OUTerror}
make install  >> ${OUTok} 2>> ${OUTerror}
SSHMAKEINSTALL_judge
#redhat
cp contrib/redhat/sshd.init /etc/init.d/sshd
#suse11以下(包括11)
#cp 159080113/openssh-7.7p1/contrib/suse/rc.sshd  /etc/init.d/sshd
chmod  +x /etc/init.d/sshd
chmod 755 ${SSHPREHOME}
chmod 755 -R  ${SSHPREHOME}/bin
}



BIN_SBIN_MV(){
for i in scp  sftp  ssh  ssh-add  ssh-agent  ssh-keygen  ssh-keyscan  sshd
do
	AA=`which $i`
	if [ $? -eq 0 ]
	then
		BB=${AA%%$i}
		\mv $AA $L_iB/${TiME}/${i}-bin-$(uuidgen)
		if [[ ${i} == sshd ]]
		then
			ln -s ${SSHPREHOME}/sbin/${i} ${BB}
		else
			ln -s ${SSHPREHOME}/bin/${i} ${BB}
		fi
	else
		if [[ ${i} == sshd ]]
		then
			if [ -h /usr/sbin/${i} ]
			then
			\mv /usr/sbin/${i}  ${L_iB}/${TiME}/${i}-sbin-$(uuidgen)
			 ln -sf ${SSHPREHOME}/sbin/${i} /usr/sbin/
			else
			ln -s ${SSHPREHOME}/sbin/${i} /usr/sbin/
			fi
		else
			if [ -h /usr/bin/${i} ]
			then
				ln -sf ${SSHPREHOME}/bin/${i} /usr/bin/
			else
				ln -s ${SSHPREHOME}/bin/${i} /usr/bin/
			fi
		fi
	fi

done

if [ -d /etc/ssh ]
then
	\mv /etc/ssh /${L_iB}/${TiME}/ssh-dir-$(uuidgen)
fi

if [ -f /etc/init.d/sshd ]
then
	\mv /etc/init.d/sshd /${L_iB}/${TiME}/sshd-init-$(uuidgen)
fi
}



SSH_INSTALL(){
	SSH_CONFIG
	sleep 1
	SSH_make
	sleep 1
	BIN_SBIN_MV
	sleep 1
	SSH_makeinsall
}


cd /tmp/159080113/
echo "################TARSSH################" >> ${OUTok}
echo "################TARSSH################" >> ${OUTerror}
tar -xzvf openssh-${SSHVerSion}.tar.gz >> ${OUTok} 2>> ${OUTerror}
echo -e "\033[32m####################TARSSH_install_ok####################\033[0m"
sleep 1
cd /tmp/159080113/openssh-${SSHVerSion}/



################编译安装#################
if [ -e /usr/local ]
then
	if [ -d /usr/local ]
	then
		SSH_INSTALL
	else
		mv /usr/local /usr/local-file-bak
		SSH_INSTALL
	fi
else
	mkdie -pv /usr/local/
	SSH_INSTALL

fi
##########################################


for i in 'SSLVerSion' 'SSHVerSion' 'SSLPREHOME' 'SSHPREHOME' 'CONFIG' 'OUTok' 'OUTerror' 'TiME' 'L_iB' 'SSHCONFIG_judge' 'SSHMAKE_judge' 'SSHMAKEINSTALL_judge' 'SSH_CONFIG' 'SSH_make' 'SSH_makeinsall' 'BIN_SBIN_MV' 'SSH_INSTALL' 'AA' 'BB' 'CC' 'TARTFILE' 

do
	unset $i
done
