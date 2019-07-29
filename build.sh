github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
del_version=$(cat delete_version.txt)

if [ $github_version != $ftp_version ]
then
    sudo apt install -y lftp
    wget https://github.com/docker/docker-ce/archive/v$github_version.zip
    unzip v$github_version.zip
    mv docker-ce-$github_version docker-ce
    cd docker-ce
    git apply --3way ../patches/*
    cd components/packaging/rpm
    VERSION=v$build_version make centos
    cd ../../../
    cd components/packaging/deb
    VERSION=v$build_version make ubuntu-xenial
    VERSION=v$build_version make ubuntu-bionic  
    cd ../../../
    
    if [[ $github_version > $ftp_version ]]
    then
        ls
    fi
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/$github_version"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/$github_version/centos-7"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/$github_version/debian-stretch"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/$github_version/ubuntu-bionic"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/$github_version/debian-stretch"
    
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R components/packaging/rpm/rpmbuild/RPMS/ppc64le/ /ppc64el/docker/$github_version"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R components/packaging/deb/debbuild/ubuntu-xenial /ppc64el/docker/$github_version/ubuntu-xenial"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R components/packaging/deb/debbuild/ubuntu-bionic /ppc64el/docker/$github_version/ubuntu-bionic"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R components/packaging/deb/debbuild/debian-stretch /ppc64el/docker/$github_version/debian-stretch"

    # lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/docker/$ftp_version"
fi
