#!/bin/bash

VerSion=1.0.2o

SSLPREHOME=/usr/local/openssl-${VerSion}

CONFIG="./config shared zlib --prefix=${SSLPREHOME}"

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




SSLCONFIG_judge(){
if [ $? -ne 0 ]
then
        echo -e "\033[31m ##########SSLconfig_error##########  \033[0m"
        exit
fi
}

SSLMAKE_judge(){
if [ $? -ne 0 ]
then
        echo -e "\033[31m ##########SSLmake_error##########  \033[0m"
        exit
fi
}


SSLMAKEINSTALL_judge(){
if [ $? -ne 0 ]
then
        echo -e "\033[31m ##########SSLmakeinstall_error##########  \033[0m"
        exit
fi
}

SSL_CONFIG(){
echo "################SSLconfigre################" >> ${OUTok}
echo "################SSLconfigre################" >> ${OUTerror}
$CONFIG >> ${OUTok} 2>> ${OUTerror}
SSLCONFIG_judge
}

SSL_make(){
echo "################SSLmake################" >> ${OUTok}
echo "################SSLmake################" >> ${OUTerror}
make  >> ${OUTok} 2>> ${OUTerror}
SSLMAKE_judge
}





SSL_makeinsall(){
echo "################SSLmakeinstall################" >> ${OUTok}
echo "################SSLmakeinstall################" >> ${OUTerror}
make install  >> ${OUTok} 2>> ${OUTerror}
SSLMAKEINSTALL_judge
chmod 755 -R  ${SSLPREHOME}/
}





BIN_SBIN_MV(){
for i in openssl
do
	AA=`which $i`
	if [ $? -eq 0 ]
	then
	BB=${AA%%$i}
	CC=${AA##/usr/}
	\mv $AA $L_iB/${TiME}
	ln -s ${SSLPREHOME}/${CC} $BB
	else
		if [ -e /usr/bin/$i ]
		then
			\mv /usr/bin/$i	$L_iB/${TiME}/$i-$(uuidgen)
		else
			ln -sf ${SSLPREHOME}/bin/$i /usr/bin
		fi
	fi

done
for i in "libssl.so.1.0.0" "libcrypto.so.1.0.0"
do
	if [ -e $L_iB/$i ]
	then
	\mv $L_iB/$i $L_iB/${TiME}/
	ln -s ${SSLPREHOME}/lib/$i $L_iB/$i
	else
	ln -s ${SSLPREHOME}/lib/$i $L_iB/$i
	fi
done

}




SSL_INSTALL(){
SSL_CONFIG
sleep 1
SSL_make
sleep 1
SSL_makeinsall
sleep 1
BIN_SBIN_MV
}



cd $TARTFILE/
echo "################TARSSL################" >> ${OUTok}
echo "################TARSSL################" >> ${OUTerror}
tar -xzvf openssl-${VerSion}.tar.gz  >> ${OUTok} 2>> ${OUTerror}
echo -e "\033[32m####################TARSSL_install_ok####################\033[0m"
cd openssl-${VerSion}


################编译安装#################
if [ -e /usr/local ]
then
	if [ -d /usr/local ]
	then
		SSL_INSTALL
	else
		mv /usr/local /usr/local-file-bak
		SSL_INSTALL
	fi
else
	mkdie -pv /usr/local/
	SSL_INSTALL
fi

##########################################
for i in 'SSLVerSion' 'SSHVerSion' 'SSLPREHOME' 'SSHPREHOME' 'CONFIG' 'OUTok' 'OUTerror' 'TiME' 'L_iB' 'SSHCONFIG_judge' 'SSHMAKE_judge' 'SSHMAKEINSTALL_judge' 'SSH_CONFIG' 'SSH_make' 'SSH_makeinsall' 'BIN_SBIN_MV' 'SSH_INSTALL' 'AA' 'BB' 'CC' 'TARTFILE'

do
	unset $i
done
