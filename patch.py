import re

print("Running Patching Script...")

deb_path = "docker-ce-packaging/deb/common/control"
deb_ver = "containerd (>= 1.2.1)"

rpm_path = "docker-ce-packaging/rpm/SPECS/docker-ce.spec"
rpm_ver = "Requires: containerd >= 1.2.1"

# Update debian containerd dependency
print("Patching DEB...")
deb = open(deb_path, 'r')
data = deb.read()
new = re.sub(r'containerd.io \([^)]*\)', deb_ver, data)
assert data != new, "Nothing was changed in the file."
open(deb_path, 'w').write(new)

# Update rpm containerd dependency
print("Patching RPM...")
rpm = open(rpm_path, 'r')
data = rpm.read()
new = re.sub(r'Requires: containerd.io [^\n]*', rpm_ver, data)
assert data != new, "Nothing was changed in the file."
open(rpm_path, 'w').write(new)

# Update gen-rpm-ver version check (Make it ignore "-dev")
newlines = []
with open('docker-ce-packaging/rpm/gen-rpm-ver', "r") as version_set:
    i = 0
    for line in version_set:
        if i == 45:
            copy = line.split(' ')
            copy[3] = '!='
            newlines.append(' '.join(copy))
        else:
            newlines.append(line)
        i += 1
        
with open('docker-ce-packaging/rpm/gen-rpm-ver', "w") as version_set:        
    version_set.writelines(newlines)

print("DONE Patching")
