#!/bin/bash
clear
echo "-------------------------------------------"
echo "Act.Framework Project Starter Kit Installer"
echo "-------------------------------------------"
echo ""
echo "(C)2017 Thinking.Studio "
echo "Written by J.Cincotta"
echo ""
echo "This installer will make sure you have everything set up so you can use the Act.Framework Starter Kit command."
echo ""
echo -n "Would you like to install Act.Framework Starter Kit? [y/n]: "
read -n 1 doinstall
echo 
INSTALL_STATUS="OK"

if [[ "${doinstall}" == 'y' ]] ; then

	#check install directory is real
    cd `dirname $0`
	BASEDIR=`pwd`
	RSRCDIR=`eval echo "${BASEDIR}/rsrc"`

	if [ -d "$BASEDIR" ]; then 
	  if [ -L "$BASEDIR" ]; then
	  	INSTALL_STATUS="Could not determine install directory."
	  fi
	fi

	if [ -d "$RSRCDIR" ]; then 
	  if [ -L "$RSRCDIR" ]; then
	  	INSTALL_STATUS="Install directory exists, but could not find rsrc directory. This would generally mean that you have a bad install."
	  fi
	fi

	if [ ! -f "$BASEDIR/act-new.sh" ]; then
	  	INSTALL_STATUS="Could not find the act-new.sh command in the install directory."
	fi

	#fix executable permissions if they are broken
	if [ ! -x "$BASEDIR/act-new.sh" ]; then
	  	chmod u+x "$BASEDIR/act-new.sh"
	fi

	if [[ "${INSTALL_STATUS}" == 'OK' ]] ; then
		echo "It looks like you have put the Act.Framework starter kit in:"
		echo $BASEDIR
		echo -n "Happy to add act-new.sh to your PATH? [y/n]: "
		read -n 1 yesno
		echo
		if [[ "${yesno}" == 'n' ]] ; then
			echo "Exiting the installer"
			echo
			exit
		fi
	   	echo "export PATH=\$PATH:$BASEDIR" >> ~/.profile
	   	echo "export PATH=\$PATH:$BASEDIR" >> ~/.bash_profile
	   	eval source ~/.bash_profile
	   	echo
	   	echo
		echo "The act-new.sh command is now installed correctly and added to your path."
		echo
	else
		echo
		echo "Install failed..."
		echo
		echo $INSTALL_STATUS
		echo
	fi
fi
echo 

