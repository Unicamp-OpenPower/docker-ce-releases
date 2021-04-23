set -e
ftp_path="ftp://oplab9.parqtec.unicamp.br/ppc64el/docker"
ftp_repo1="ftp://oplab9.parqtec.unicamp.br/repository/debian/ppc64el/docker"
ftp_repo2="ftp://oplab9.parqtec.unicamp.br/repository/rpm/ppc64le/docker"
url="https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker"

home_dir=$(pwd)
git_ver=$(cat github_version.txt)
moby_ver=$(cat moby_version.txt)
ftp_ver=$(cat ftp_version.txt)
# del_version=$(cat delete_version.txt)

echo "=========> [CHECKING IF BUILD EXISTS] >>> "
if [ $git_ver != $ftp_ver ] && [ $git_ver == $ftp_ver ]
then
    
    echo "=========> [CLONNING <$git_ver> AND PATCHING] >>>"
    sudo apt -y install make
    printf "deb https://oplab9.parqtec.unicamp.br/pub/repository/debian/ ./\n" >> /etc/apt/sources.list
    wget https://oplab9.parqtec.unicamp.br/pub/key/openpower-gpgkey-public.asc
    sudo apt-key add openpower-gpgkey-public.asc
    sudo apt-get update
    sudo apt-get -y install docker-ce

    git clone https://github.com/docker/cli.git
    git clone https://github.com/moby/moby.git
    git clone https://github.com/docker/scan-cli-plugin.git
    git clone https://github.com/docker/docker-ce-packaging.git

    cd cli
    git checkout v$git_ver
    cd ..

    cd moby
    git checkout v$git_ver
    cd ..

    python3 patch.py
    mkdir -p docker-ce-packaging/src/github.com/docker/cli
    mkdir -p docker-ce-packaging/src/github.com//docker/docker
    mkdir -p docker-ce-packaging/src/github.com/docker/scan-cli-plugin

    sudo cp -r cli/* docker-ce-packaging/src/github.com/docker/cli
    sudo cp -r moby/* docker-ce-packaging/src/github.com/docker/docker
    sudo cp -r scan-cli-plugin/* docker-ce-packaging/src/github.com/docker/scan-cli-plugin

    echo "=========> [BUILDING <$sys> PACKAGES] >>>"
    cd $dir
    sudo make $sys
    cd && cd $bin_dir
    ls

    cd $home_dir/$dir
    sudo VERSION=$git_ver make $sys

    echo "=========> [CREATING FTP FOLDER] >>> "
    lftp -c "open -u $USER,$PASS $ftp_path; mkdir -p version-$git_ver/$sys"

    echo "=========> [SENDING PACKAGES TO FTP] >>>"
    cd $home_dir/$bin_dir
    lftp -c "open -u $USER,$PASS $ftp_path/version-$git_ver/$sys; mirror -R ./ ./"
    sudo rm -rf $home_dir/$bin_dir

    if [ ${sys} == "ubuntu-focal" ]
    then
      echo "=========> [SENDING PACKAGES TO REPOSITORY <$sys>] >>>"
      cd $home_dir
      mkdir upload
      cd upload
      wget https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker/version-$git_ver/ubuntu-bionic/docker-ce-cli_$git_ver~3-0~ubuntu-focal_ppc64el.deb
      wget https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker/version-$git_ver/ubuntu-bionic/docker-ce_$git_ver~3-0~ubuntu-focal_ppc64el.deb
      lftp -c "open -u $USER,$PASS $ftp_repo1; mirror -R ./ ./"
      cd ..
      rm -rf upload/
    fi
    if [ ${sys} == "centos-7" ]
    then
      echo "=========> [SENDING PACKAGES TO REPOSITORY <$sys>] >>>"
      cd $home_dir
      mkdir upload
      cd upload
      wget https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker/version-$git_ver/centos/docker-ce-$git_ver-3.el7.ppc64le.rpm
      wget https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker/version-$git_ver/centos/docker-ce-cli-$git_ver-3.el7.ppc64le.rpm
      lftp -c "open -u $USER,$PASS $ftp_repo2; mirror -R ./ ./"
      cd ..
      rm -rf upload/
    fi
    if [ ${sys} == "centos-8" ]
    then
      echo "=========> [SENDING PACKAGES TO REPOSITORY <$sys>] >>>"
      cd $home_dir
      mkdir upload
      cd upload
      wget https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker/version-$git_ver/centos/docker-ce-$git_ver-3.el8.ppc64le.rpm
      wget https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker/version-$git_ver/centos/docker-ce-cli-$git_ver-3.el8.ppc64le.rpm
      lftp -c "open -u $USER,$PASS $ftp_repo2; mirror -R ./ ./"
      cd ..
      rm -rf upload/
    fi


fi

echo "=========> [DONE]"
