import requests
from re import findall

# function get_info
#   Creates a file <name> whith the highest version found of a version 
#   (string) within the given path. If not found, writes '0'  
# Parameters:
#   path  - URL where to look for the info
#   regex - Pattern of what to look for in the path to locate the info
#   name  - Name of the text file to be written with the info
#   cut -  funtion indicating what to keep from the regex pattern
def get_info(path, regex, name, cut=(lambda x : x)):
    html = str(requests.get(path).content)
    info = cut(max(findall(regex, html)+["0"]))
    file = open(name+'.txt', 'w')
    file.writelines(info)
    file.close()

# Define the FTP URL for downloading and uploading packages
# ftp_path = 'https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker'
ftp_path = 'https://oplab9.parqtec.unicamp.br/pub/test/vinicius/'
git_path = 'https://github.com/docker/docker-ce/releases/latest'

# find and save the current Github release
get_info(git_path, 'v\d\d[.]\d\d[.]\d', 'github_version', cut=(lambda x : x[1:]))

# find and save the current Docker version on FTP server
get_info(ftp_path, '\d\d[.]\d\d[.]\d', 'ftp_version')
