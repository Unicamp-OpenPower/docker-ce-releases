ftp_path="ftp://oplab9.parqtec.unicamp.br/ppc64el/docker"
url="https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker"

home_dir=$(pwd)
# git_ver=$(cat github_version.txt)
ftp_ver=$(cat ftp_version.txt)
# del_version=$(cat delete_version.txt)

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


echo "=========> [DONE]"
