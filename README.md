# Newt-Scamander-SRE_infra
Newt-Scamander-SRE Infra repository
# HW_03 ((Lecture 5) Meeting with cloud infrastructure. Yandex Cloud)

1. приватные ключи - в keepassxc, шарятся в хост только после разблокировки, при блокировке базы - удаляются из кеша  *See: **Usefull commands** *.
2. в etc/.ssh/ - только публичные ключи и конфигурационный файл для распределения по подключаемым хостам.
3. подключение к jump-host (выполнено успешно):
```
ssh -J some-name@jump-host-ip:port the-same-name@internal-host-ip -p port
```


4. alias позволяющий попасть сразу во внутренний хост по команде:
```
ssh otus-int-host1
```

5. параметры ssh/config:
```
Host otus-jh_yandex_cloud
 Hostname 158.160.0.243
 IdentityFile ~/.ssh/ya-cloud-otus-key.pub

Host otus-int-host1
 Hostname 10.129.0.32
 ProxyJump otus-jh_yandex_cloud
 User localuser
 IdentityFile ~/.ssh/ya-cloud-otus-key.pub
```
6. pritunl = web gui + openvpn.

7. Web access сгенерированным валидным ssl для админки:
https://158.160.28.114.sslip.io/login

8.  Данные для подключения:

bastion_IP = 158.160.28.114
someinternalhost_IP = 10.129.0.32


### Usefull commands:

ssh:

```
ssh-add -L
# show added ssh-key in cache
```
# HW_04 Deploy test cloud-application (Lecture 6)


## Information for Testapp branch:
testapp_IP = 51.250.91.9

testapp_port = 9292
- `this IP will change after next deploy. Output should be used instead! {network_interfaces:index:primary_v4_address:one_to_one_nat:address:<IP>`


Custom scripts for ruby&mongo&deploy:
> install_mongodb.sh

> install_ruby.sh

> deploy.sh


Usefull script:
```
startup.sh
```
- `will be create vm && deploy application`

### Usefull commands:
```
yc compute instance list
yc config list
yc config profile list
yc config profile get cloud-otus-sea-profile
yc compute image list --folder-id standard-images | grep ubuntu
#if you create ssh-key.pub, default user for them: yc-user,
alternative- using cloud-config
#
```
# HW_05: using Packer to create "golden image" (Lecture 7)
**Done everything possible**



### Usefull commands:

```
yc resource-manager folder add-access-binding --id=<folderID> --role editor --service-account-id=<Service-account-id>

```
```
packer validate -var-file=some-env-file.json some-target-file.json
packer build -var-file=some-env-file.json some-target-file.json
```



`YC packer notes`:
- Just one of a *source_image_id*  or *source_image_family* must be specified.

# HW_06: terraform_1 + ya_cloud
**road_move**
- First step: Instance with app created
- Second step: adding load balancer with increase count for instance
