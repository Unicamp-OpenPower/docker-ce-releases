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
    VERSION=$build_version make centos
    cd ../../../
    cd components/packaging/deb
    VERSION=$build_version make ubuntu-xenial
    VERSION=$build_version make ubuntu-bionic  
    cd ../../../
    if [[ $github_version > $ftp_version ]]
    then
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/rpm/latest/$github_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R components/packaging/rpm/rpmbuild/RPMS/ppc64le/ /ppc64el/docker/rpm/latest/$github_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/docker/rpm/latest/$ftp_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/deb/latest/$github_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R components/packaging/deb/debbuild/ /ppc64el/docker/deb/latest/$github_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/docker/deb/latest/$ftp_version"
    fi
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/rpm/$github_version"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R components/packaging/rpm/rpmbuild/RPMS/ppc64le/ /ppc64el/docker/rpm/$github_version"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/docker/rpm/$ftp_version"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/deb/$github_version"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R components/packaging/deb/debbuild/ /ppc64el/docker/deb/$github_version"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/docker/deb/$ftp_version"
fi
