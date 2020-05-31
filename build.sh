set -e
ftp_path="ftp://oplab9.parqtec.unicamp.br/ppc64el/docker"
url="https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker"

home_dir=$(pwd)
git_ver=$(cat github_version.txt)
ftp_ver=$(cat ftp_version.txt)
# del_version=$(cat delete_version.txt)

echo "=========> [CHECKING IF BUILD EXISTS] >>> "
status=$(curl -s --head -w %{http_code} $url/version-$git_ver/$sys -o /dev/null) 
if [ $status == 404 ] 
then

    echo "=========> [CLONNING <$git_ver> AND PATCHING] >>>"
    git clone https://github.com/docker/docker-ce
    cd docker-ce && git checkout v$git_ver
    git config --global user.name "Vinicius Espindola"
    git config --global user.email "vini.couto.e@gmail.com"
    python3 ../patch.py
    git add . && git commit -m "using community containerd versions"

    echo "=========> [BUILDING <$sys> PACKAGES] >>>"
    cd $home_dir/$dir
    sudo VERSION=$git_ver make $sys

    echo "=========> [CREATING FTP FOLDER] >>> "
    lftp -c "open -u $USER,$PASS $ftp_path; mkdir -p version-$git_ver/$sys"

    echo "=========> [SENDING PACKAGES TO FTP] >>>"
    cd $home_dir/$bin_dir
    lftp -c "open -u $USER,$PASS $ftp_path/version-$git_ver/$sys; mirror -R ./ ./"
    sudo rm -rf $home_dir/$bin_dir

fi

echo "=========> [DONE]"
