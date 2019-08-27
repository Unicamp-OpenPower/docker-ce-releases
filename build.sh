#github_version=$(cat github_version.txt)
#github_version="18.09.0"
#github_version="18.09.1"
#github_version="18.09.2"
#github_version="18.09.3"
#github_version="18.09.4"
#github_version="18.09.5"
#github_version="18.09.6"
#github_version="18.09.7"
github_version="19.03.1"
ftp_version=$(cat ftp_version.txt)
del_version=$(cat delete_version.txt)
status=$(curl -s --head -w %{http_code} https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker/version-$github_version/$sys -o /dev/null)

if [  $status == 404 ] 
then
    echo "VALIDACAO 1"
    sudo apt install -y lftp
    
    echo "VALIDACAO 2"
    status=$(curl -s --head -w %{http_code} https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker/version-$github_version -o /dev/null)
    
    echo "VALIDACAO 3"
    if [[ $status == 404 ]]
    then
        echo "VALIDACAO 3.5"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/docker/version-$github_version"
        #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/docker/$ftp_version"
    fi
    
    echo "VALIDACAO 4"
    wget https://github.com/docker/docker-ce/archive/v$github_version.zip
    
    echo "VALIDACAO 5"
    unzip v$github_version.zip
    
    echo "VALIDACAO 6"
    mv docker-ce-$github_version docker-ce
    
    echo "VALIDACAO 7"
    cd docker-ce && git apply --3way ../patches/*
    
    echo "VALIDACAO 8"
    cd $dir
    
    echo "VALIDACAO 9"
    VERSION=$github_version make $sys
    
    echo "VALIDACAO 10"
    cd ../../../
    
    echo "VALIDACAO 11"
    cd $bin_dir
    
    #if [[ $github_version > $ftp_version ]]
    #then
        
    #fi
    echo "VALIDACAO 12"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mirror -R ./ /ppc64el/docker/version-$github_version/$sys"
fi
