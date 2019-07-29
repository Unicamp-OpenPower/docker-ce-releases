github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
del_version=$(cat delete_version.txt)

if [ 3 > 2 ] # $github_version != $ftp_version
then
    sudo apt install -y lftp
    wget https://github.com/docker/docker-ce/archive/v$github_version.zip
    unzip v$github_version.zip
    mv docker-ce-$github_version docker-ce
    cd docker-ce
    git apply --3way ../patches/*
    make static-linux
    #
    cd components/packaging/static/
    ls
    cd ../../../
    cd components/packaging/static/build
    ls
    cd ../../../../
    cd components/packaging/static/build/linux
    ls
    cd ../../../../../
    #cd components/packaging/rpm
    #make centos
    #cd ../../../
    #cd components/packaging/deb
    #make ubuntu-xenial
    #make ubuntu-bionic
    #make debian-stretch
    #cd ../../../
    
    if [[ $github_version > $ftp_version ]]
    then
        ls
    fi
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R components/packaging/static/build/linux /ppc64el/docker/version-$github_version"

    #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/version-$github_version"
    #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/version-$github_version/centos-7"
    #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/version-$github_version/debian-stretch"
    #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/version-$github_version/ubuntu-bionic"
    #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/version-$github_version/debian-stretch"
    
    #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R components/packaging/rpm/rpmbuild/RPMS/ppc64le/ /ppc64el/docker/version-$github_version/centos-7"
    #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R components/packaging/deb/debbuild/ubuntu-xenial /ppc64el/docker/version-$github_version/ubuntu-xenial"
    #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R components/packaging/deb/debbuild/ubuntu-bionic /ppc64el/docker/version-$github_version/ubuntu-bionic"
    #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R components/packaging/deb/debbuild/debian-stretch /ppc64el/docker/version-$github_version/debian-stretch"

    # lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/docker/$ftp_version"
fi
