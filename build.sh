ftp_path="ftp://oplab9.parqtec.unicamp.br/test/vinicius/docker"
url="https://oplab9.parqtec.unicamp.br/pub/test/vinicius/docker"

home_dir=$(pwd)
git_ver=$(cat github_version.txt)
ftp_ver=$(cat ftp_version.txt)
# del_version=$(cat delete_version.txt)

echo "=========> [CHECKING IF BUILD EXISTS] >>> "
status=$(curl -s --head -w %{http_code} $url/version-$git_ver/$sys -o /dev/null) 
if [ $status == 404 ] 
then

    echo "=========> [CREATING FTP FOLDER] >>> "
    sudo apt install -y lftp
    lftp -c "open -u $USER,$PASS $ftp_path; mkdir -p version-$git_ver/$sys"

    echo "=========> [INSTALLING DOCKER] >>> "
    git clone https://github.com/Unicamp-OpenPower/docker.git
    sudo snap install docker

    echo "=========> [CLONNING <$git_ver> AND PATCHING] >>>"
    git clone https://github.com/docker/docker-ce
    cd docker-ce && git checkout v$git_ver
    git apply -v --3way ../patches/*

    echo "=========> [BUILDING <$sys> PACKAGES] >>>"
    cd $home_dir/$dir
    VERSION=$git_ver make $sys

    echo "=========> [SENDING PACKAGES TO FTP] >>>"
    cd $home_dir/$bin_dir
    lftp -c "open -u $USER,$PASS $ftp_path/version-$git_ver/$sys; mirror -R ./ ./"

fi

echo "=========> [DONE]"
