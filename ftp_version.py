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

# Define the FTP URL for downloading and uploading packages
ftp_path = 'https://oplab9.parqtec.unicamp.br/pub/ppc64el/docker'
git_path = 'https://github.com/docker/docker-ce/releases/latest'

# find and save the current Github release
get_info(git_path, 'v\d\d\.\d\d\.\d+', 'github_version', cut=(lambda x : x[1:]))

# find and save the current Docker version on FTP server
get_info(ftp_path, '\d\d\.\d\d\.\d+', 'ftp_version')
