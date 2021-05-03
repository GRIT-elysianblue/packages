#!/usr/bin/env bash
###
# GuidePoint Manual Velociraptor Uninstallation Scirpt
# Platform: Linux - DEB and RPM based
# Author: Wes Riley (wes.riley@guidepoingsecurity.com)
# Date: 29 APR 2021

function usage {
    echo "Guidepoint Velociraptor Uninstallation Script."
    echo "Usage: ./vr-uninstaller.sh -[r|d|h]"
    echo "  -r : Option for CentOS/RHEL/SuSe Systems."
    echo "  -d : Option for Ubuntu/Debian Systems."
    echo "  -m : Manual uninstallation instructions."
    echo "  -h : Print this message."
}

function manual_uninstall {
    echo "Manual Uninstallation required, remove the following files:"
    echo "- /usr/local/bin/velociraptor"
    echo "- /usr/local/sbin/velociraptor"
    echo "- /usr/local/sbin/velociraptor.config.yaml"
    echo "- /etc/velociraptor/client.config.yaml"
    echo "Then remove the service via:"
    echo "- systemctl stop velociraptor_client"
    echo "- systemctl disable velociraptor_client"
    echo "- systemctl daemon-reload"
}

function raptor_file_check {
    echo "[-] Checking for Velociraptor config file in /etc/velociraptor"
    config_check=$(ls /etc/velociraptor/client.config.yaml)
    if [ $? -eq 0 ]; then
        echo "[!] Velociraptor config file found at: /etc/velociraptor/client.config.yaml"
    else
        echo "[-] Checking for Velociraptor config file in /usr/local/sbin"
        config_check=$(ls /usr/local/sbin/velociraptor.config.yaml)
        if [ $? -eq 0 ]; then 
            echo "[!] Velociraptor config file found at: /usr/local/sbin/velociraptor.config.yaml"
        else
            echo "[+] Velociraptor config file not found."
        fi
    fi
    echo "[-] Checking for Velociraptor binary in /usr/local/bin"
    bin_check=$(ls /usr/local/bin/velociraptor)
    if [ $? -eq 0 ]; then
        echo "[!] Velociraptor binary found at: /usr/local/bin/velociraptor"
    else
        echo "[-] Checking for Velociraptor binary at /usr/local/sbin"
        bin_check=$(ls /usr/local/sbin/velociraptor)
        if [ $? -eq 0 ]; then
            echo "[!] Velociraptor binary found at /usr/local/sbin/velociraptor"
        else
            echo "[+] Velociraptor binary not found"
        fi
    fi
}

function rhel_remove {
    RHEL=$(cat /etc/redhat-release)

    if [ $? -eq 0 ]; then
        echo "[-] Checking for Velociraptor RPM package installation"
        VR_RPM=$(rpm -qa | grep velociraptor )
        if [ $? -eq 0 ]; then
            echo "[+] Found: ${VR_RPM}"
            echo "[-] Removing ${VR_RPM} via 'yum -y remove ${VR_RPM}"
            YUM_UNINST=$(yum -y remove ${VR_RPM})
            if [ $? -eq 0 ]; then
                echo "[+] RPM uninstalled via 'yum -y remove ${VR_RPM}'"
                echo ${YUM_UNINST}
            else
                echo "[!} Yum uninstallation unsuccessful.  Attempting RPM command."
                echo "[-] Removing ${VR_RPM} via 'rpm -e ${VR_RPM}"
                RPM_UNINST=$(rpm -e ${VR_RPM})
                if [ $? -eq 0 ]; then
                    echo "RPM uninstalled via 'rpm -e ${RPM_UNINST}'"
                    echo ${RPM_UNINST}
                else
                    echo "[!] DPKG uninstallation failed. Manual removal required."
                    raptor_file_check
                    manual_uninstall
                    exit
                fi
            fi
        fi
    fi
    raptor_file_check
}

function deb_remove {
    DEBIAN=$(cat /etc/lsb-release)

    if [ $? -eq 0 ]; then
        echo "[-] Uninstalling Velociraptor via 'apt -y remove velociraptor-client'"
        VR_APT=$(apt -y remove velociraptor-client)
        if [ $? -eq 0 ]; then
            echo "[+] DEB uninstalled via 'apt remove velociraptor-client'"
            echo ${VR_APT}
        else
            echo "[!] Uninstallation via APT failed, attempting 'dpkg -P velociraptor-client'"
            VR_DEB=$(dpkg -P velociraptor-client)
            if [ $? -eq 0 ]; then
                echo "[+] DEB uninstalled via 'dpkg -P velociraptor-client'"
                echo ${VR_DEB}
            else
                echo "[!] DPKG uninstallation failed.  Manual removal required."
                raptor_file_check
                manual_uninstall
                exit
            fi
        fi
    fi
    raptor_file_check
}

## Begin main
while getopts r:d:m:h: flag
do
    case "${flag}" in
        r) rpm_remove;;
        d) deb_remove;;
        m) manual_uninstall;;
        h) usage;;
    esac
done

