#github_version=$(cat github_version.txt)
#github_version="18.09.0"
#github_version="18.09.1"
#github_version="18.09.2"
#github_version="18.09.3"
#github_version="18.09.4"
#github_version="18.09.5"
#github_version="18.09.6"
#github_version="18.09.7"
github_version="18.09.7"
ftp_version=$(cat ftp_version.txt)
del_version=$(cat delete_version.txt)
status=$(curl -s --head -w %{http_code} https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker/version-$github_version/$sys -o /dev/null)

if [  $status == 404 ] 
then
    sudo apt install -y lftp
    status=$(curl -s --head -w %{http_code} https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker/version-$github_version -o /dev/null)
    if [[ $status == 404 ]]
    then
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/version-$github_version"
        #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/docker/$ftp_version"
    fi
    
    wget https://github.com/docker/docker-ce/archive/v$github_version.zip
    unzip v$github_version.zip
    mv docker-ce-$github_version docker-ce
    cd docker-ce && git apply --3way ../patches/*
    cd $dir
    VERSION=$github_version make $sys
    cd ../../../
    cd $bin_dir
    
    #if [[ $github_version > $ftp_version ]]
    #then
        
    #fi
    
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R ./ /ppc64el/docker/version-$github_version/$sys"
fi
