import re

print("Running Patching Script...")

deb_path = "components/packaging/deb/common/control"
deb_ver = "containerd (>= 1.2.1)"

rpm_path = "components/packaging/rpm/SPECS/docker-ce.spec"
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

print("DONE Patching")
