# Newt-Scamander-SRE_infra
Newt-Scamander-SRE Infra repository
(данные неточные, нужно заполнить акуратнее)
| Homework №| Additional task  | Usefull tips |
| --------- | --------------- | --------------|
|- [HW-09](#hw_09-ansible-2) |[x] Additional task done | [tips]()|
|- [HW-08](#hw_08-ansible_01) | [ ] Additional task done| |
|- [HW-07](#hw_07-terraform_2) | [ ] Additional task done| |
|- [HW-06](#hw_06-terraform_1--ya_cloud) | [ ] Additional task done| |
|- [HW-05](#hw_05-using-packer-to-create-golden-image-lecture-7) | [x] Additional task done| [tips](#usefull-commands-hw_05)|
|- [HW-04](#hw_04-deploy-test-cloud-application-lecture-6) | [ ] Additional task done|[tips](#usefull-commands-hw_04) |
|- [HW-03](#hw_03-lecture-5-meeting-with-cloud-infrastructure-yandex-cloud) |[ ] Additional task done |[tips](#usefull-commands-hw_03) |

### HW_09: Ansible-2
<details>
<summary> Detailed of homework Ansible-2 </summary>
- Задание выполнено в полном объеме, включая "*"
packer-ом пересобраны образы дисков.
после раскатки terraformom stage, запуском ansible-playboook докатываются настройки.
имена хостов, ip в том числе внутренний ip базы - задаются через переменные собираемые через динамик инвентори.

*про keyed_groups - непонятно немного - походу просто какие-то комьюнити скрипты для формирования динамических групп.

*При запуске следить за состоянием keepasxc, который при блокировке выгружает ключи из агента!*
</details>

##### [Content](#newt-scamander-sre_infra)
----

### HW_08: Ansible_01
- реализован странный способ формировать динамический инвентарь в json формат, используя python и cli yc (yandex cloud)
запуск команды
```
ansible all -m ping
```
выполняет ya_auto_inv, заданный в ansible.cfg, формирую инвентарь для ansible и заодно сохраняя в файл результат "инвентаризации".
*Для статической и динамической инвентаризации, которую можно задать закомеентировав строки в ansible.cfg - отдельные файлы*
 Все отличия статического инвентори json от динамического - в наличии метаданных.
- Postmortem:
 ***динамическая инвентаризации - прикольная штука, в виду распространенности вывода данных по rest api в json***

##### [Content](#newt-scamander-sre_infra)
----

### HW_07: terraform_2
postmorten:
разделение VM c сервисом на два инстанса.
Основная проблема - не запутаться в переменных.
Два гвоздя - после разделения нужно:
1) Указать приложению адрес db по сгенерированному ip
2) открыть подключение к db со стороны приложения
Внимательнее относиться к service.key провайдера (например, добавлять в gitignore фильтр по маске *.key)
При утечке ключа - пересоздавать сервисный аккаунт и обвновлять к нему ключ.
(На будующее реализовать выдачу ключа самим терраформом непосредственно под проект?)

##### [Content](#newt-scamander-sre_infra)
----

### HW_06: terraform_1 + ya_cloud [Content](#newt-scamander-sre_infra)
**road_move**
- First step: Instance with app created
- Second step: adding load balancer with increase count for instance

##### [Content](#newt-scamander-sre_infra)
----

### HW_05: using Packer to create "golden image" (Lecture 7)
**Done everything possible**

#### Usefull commands (HW_05):

```
yc resource-manager folder add-access-binding --id=<folderID> --role editor --service-account-id=<Service-account-id>

```
```
packer validate -var-file=some-env-file.json some-target-file.json
packer build -var-file=some-env-file.json some-target-file.json
```



`YC packer notes`:
- Just one of a *source_image_id*  or *source_image_family* must be specified.

##### [Content](#newt-scamander-sre_infra)
----

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

#### Usefull commands (HW_04):
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
##### [Content](#newt-scamander-sre_infra)
----

### HW_03 ((Lecture 5) Meeting with cloud infrastructure. Yandex Cloud)

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

#### Usefull commands (HW_03):

ssh:

```
ssh-add -L
# show added ssh-key in cache
```
##### [Content](#newt-scamander-sre_infra)
----
