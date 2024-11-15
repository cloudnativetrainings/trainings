# general
is it possible to hide the img folder via .img???
enable autoscaling of k1 cluster
disable telemtry
add images to applications

# broken labs
oauth
user-mla (including upgrading usermla?)
k8s dashboard => probably due to only doable via oauth not via static passwords

# new labs
backups => minio => k1 backup into k1 training
API -> terraform provider instead of curl API
custom links to kkp, eg api
no OPA (outdated) and no kyverno (int implemented yet) 

# sync with Tobi and Koray (order of things is prio)
[optional] cluster cleanup cronjob => all clusters without a specific label => if time allows
[optional] OSP
[optional] kuberntes user cluster version range setting in kkp
[optional] custom job to patch specs => to show how extensible kkp is
[optional] custom links
[optional] seperate md for user-mla => taints and tolerations
[optional] customizing mla
[optional] custom image mirror
[optional] kubevirt tech intro => eg run a KVM on a hetzner Bare Metal Machine and make use of provider
[optional] edge provisioner 
[optional] kubelb
--- rather unrealistic stuff
[optional] kcs
[optional] kdp
[optional] airgapped - to hard to train => ref repo