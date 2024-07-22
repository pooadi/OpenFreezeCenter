#!/bin/bash

FLAG_1=0
FLAG_2=0
FLAG_3=0

##############################################################################################
# Moving files to desktop and making virtual environment and installing all the dependencies #
##############################################################################################

if test -f ~/Bash_Scripts/Fan_Control/OFC.py;
then
    FLAG_3=1
else
    echo "This is a shell script to install all the dependencies required for this software to run."
    echo "Dependencies required are as follows."
    echo "1 -> python3-virtualenv AND python3-venv"
    echo "2 -> PyGObject" 
    echo "3 -> PyCairo" 
    echo "4 -> Expert" 
    echo "----------Creating Folder for Open Freeze Center----------"
    cd ~/Bash_Scripts
    mkdir Fan_Control
    echo "----------Installing python3-virtualenv AND python3-venv and other dependencies----------"
    sudo apt update
    sudo apt upgrade
    sudo apt install python3-virtualenv python3-venv libgirepository1.0-dev libcairo2-dev
    echo "----------Creating Virtual Environment for Open Freeze Center----------"
    python3 -m venv ~/Bash_Scripts/Fan_Control
    echo "----------Virtual Environment for Open Freeze Center created----------"
    echo "----------Installing PyGObject----------"
    ~/Bash_Scripts/Fan_Control/bin/pip3 install PyGObject
    echo "----------Installing PyCairo----------"
    ~/Bash_Scripts/Fan_Control/bin/pip3 install pycairo
    echo "----------Installing Expert----------"
    sudo apt-get install expect
    echo "----------Moving files to virtual environment----------"
    cp -i ~/Repos/OpenFreezeCenter/install.sh  ~/Bash_Scripts/Fan_Control/
    cp -i ~/Repos/OpenFreezeCenter/file_1.sh  ~/Bash_Scripts/Fan_Control/
    cp -i ~/Repos/OpenFreezeCenter/file_2.sh  ~/Bash_Scripts/Fan_Control/
    cp -i ~/Repos/OpenFreezeCenter/OFC.py  ~/Bash_Scripts/Fan_Control/
    cp -i ~/Repos/OpenFreezeCenter/README.md  ~/Bash_Scripts/Fan_Control/
    cp -i ~/Repos/OpenFreezeCenter/LICENSE  ~/Bash_Scripts/Fan_Control/
    FLAG_3=1
fi

################################
# Prepairing the EC read/write #
################################

if test -d /etc/modprobe.d;
then
    if test -f /etc/modprobe.d/ec_sys.conf;
    then
        if grep -q "options ec_sys write_support=1" "/etc/modprobe.d/ec_sys.conf";
        then FLAG_1=1
        else
            echo "----------Prepairing system for EC read/write----------"
            cd ~/Bash_Scripts/Fan_Control/
            sudo ./file_1.sh
            FLAG_1=1
        fi
    else
        echo "----------Prepairing system for EC read/write----------"
        sudo touch /etc/modprobe.d/ec_sys.conf
        cd ~/Bash_Scripts/Fan_Control/
        sudo ./file_1.sh
        FLAG_1=1
    fi
else
    echo "----------Prepairing system for EC read/write----------"
    mkdir /etc/modprobe.d
    sudo touch /etc/modprobe.d/ec_sys.conf
    cd ~/Bash_Scripts/Fan_Control/
    sudo ./file_1.sh
    FLAG_1=1
fi

if test -d /etc/modules-load.d;
then
    if test -f /etc/modules-load.d/ec_sys.conf;
    then
        if grep -q "ec_sys" "/etc/modules-load.d/ec_sys.conf";
        then FLAG_2=1
        else
            echo "----------Prepairing system for EC read/write----------"
            cd ~/Bash_Scripts/Fan_Control/
            sudo ./file_2.sh
            FLAG_2=1
        fi
    else
        echo "----------Prepairing system for EC read/write----------"
        sudo touch /etc/modules-load.d/ec_sys.conf
        cd ~/Bash_Scripts/Fan_Control/
        sudo ./file_2.sh
        FLAG_2=1
    fi
else
    echo "----------Prepairing system for EC read/write----------"
    mkdir /etc/modules-load.d
    sudo touch /etc/modules-load.d/ec_sys.conf
    cd ~/Bash_Scripts/Fan_Control/
    sudo ./file_2.sh
    FLAG_2=1
fi

if [ "$FLAG_1" -eq 1 ] && [ "$FLAG_2" -eq 1 ];
then
    echo "----------EC read/write is enabled----------"
else
    echo "----------EC read/write is can not be enabled----------"
fi

if [ "$FLAG_3" -eq 1 ];
then
    if test -f ~/Bash_Scripts/Fan_Control/config.py;
    then
        echo "----------Running Software----------"
        sudo nohup ~/Bash_Scripts/Fan_Control/bin/python3 ~/Bash_Scripts/Fan_Control/OFC.py
    else
        echo "----------Running Software----------"
        sudo nohup ~/Bash_Scripts/Fan_Control/bin/python3 ~/Bash_Scripts/Fan_Control/OFC.py
    fi
fi
