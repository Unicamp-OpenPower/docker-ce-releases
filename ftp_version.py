import requests
import urllib.request as request
from re import findall

# Parse version in tuple of numbers
parse = lambda x: [x[:],tuple(list(map(int, x.split('.'))))]

# function get_info
#   Creates a file <name> whith the highest version found of a version 
#   (string) within the given path. If not found, writes '0'  
# Parameters:
#   path  - URL where to look for the info
#   regex - Pattern of what to look for in the path to locate the info
#   name  - Name of the text file to be written with the info
#   cut -  funtion indicating what to keep from the regex pattern
def get_info(path, regex, name, cut=(lambda x : x)):
    html = str(request.urlopen(path).read())
    vers = [x[1:] if x[0]=='v' else x for x in findall(regex, html)]
    latest = max(list(map(parse, vers)), key=lambda x: x[1])[0]
    file = open(name+'.txt', 'w')
    file.writelines(latest)
    file.close()
    return(latest)

# Define the FTP URL for downloading and uploading packages
ftp_path = 'https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker'
git_path = 'https://github.com/docker/cli/releases/latest'
moby_path = 'https://github.com/moby/moby/releases/latest'

# find and save the current Github release
git_ver = get_info(git_path, 'v\d\d\.\d\d\.\d+', 'github_version', cut=(lambda x : x[1:]))
moby_ver = get_info(moby_path, 'v\d\d\.\d\d\.\d+', 'moby_version', cut=(lambda x : x[1:]))

# find and save the current Docker version on FTP server
ftp_ver = get_info(ftp_path, '\d\d\.\d\d\.\d+', 'ftp_version')

# Find if there are already the builds for each system
html = str(
    requests.get(
        'https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker/version-' + git_ver
    ).content)

# Create a file if there isn't a build
if (not 'ubuntu-focal' in html):
    file = open('ubuntu-focal.txt', 'w')
    file.writelines(ftp_version)
    file.close()
if (not 'ubuntu-bionic' in html):
    file = open('ubuntu-bionic.txt', 'w')
    file.writelines(ftp_version)
    file.close()
if (not 'debian-buster' in html):
    file = open('ubuntu-buster.txt', 'w')
    file.writelines(ftp_version)
    file.close()
if (not 'centos-8' in html):
    file = open('centos-8.txt', 'w')
    file.writelines(ftp_version)
    file.close()
if (not 'centos-7' in html):
    file = open('centos-7.txt', 'w')
    file.writelines(ftp_version)
    file.close()
