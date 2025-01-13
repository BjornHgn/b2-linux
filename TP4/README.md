# TP4 : Vers une maîtrise des OS Linux

# I. Partitionnement

## 1. LVM dès l'installation

🌞 **Faites une install manuelle de Rocky Linux**

```shell
[root@vbox ~]# lsblk
NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                8:0    0   40G  0 disk
├─sda1             8:1    0    2G  0 part /boot
└─sda2             8:2    0   21G  0 part
  ├─rl_vbox-root 253:0    0   10G  0 lvm  /
  ├─rl_vbox-swap 253:1    0 1000M  0 lvm  [SWAP]
  ├─rl_vbox-var  253:2    0    5G  0 lvm  /var
  └─rl_vbox-home 253:3    0    5G  0 lvm  /home
sr0               11:0    1 1024M  0 rom
[root@vbox ~]# pvs
  PV         VG      Fmt  Attr PSize   PFree
  /dev/sda2  rl_vbox lvm2 a--  <20.98g    0
[root@vbox ~]# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               rl_vbox
  PV Size               20.98 GiB / not usable 4.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              5370
  Free PE               0
  Allocated PE          5370
  PV UUID               UVcwCo-gAMR-ae9U-Gj6w-kPXx-X642-io2fMK
```

```shell
[root@vbox ~]# vgdisplay
  --- Volume group ---
  VG Name               rl_vbox
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  5
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                4
  Open LV               4
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <20.98 GiB
  PE Size               4.00 MiB
  Total PE              5370
  Alloc PE / Size       5370 / <20.98 GiB
  Free  PE / Size       0 / 0
  VG UUID               g0S0Pl-RtFE-TtP7-ZdV9-0HQL-mGEH-02CiIp
```

```shell
[root@vbox ~]# lvdisplay
  --- Logical volume ---
  LV Path                /dev/rl_vbox/swap
  LV Name                swap
  VG Name                rl_vbox
  LV UUID                0vhovT-2DSh-nLS0-k3jq-Uo3E-RUTq-Np18BR
  LV Write Access        read/write
  LV Creation host, time vbox, 2025-01-13 10:02:12 +0100
  LV Status              available
  # open                 2
  LV Size                1000.00 MiB
  Current LE             250
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1

  --- Logical volume ---
  LV Path                /dev/rl_vbox/var
  LV Name                var
  VG Name                rl_vbox
  LV UUID                RtsBem-LwTM-M2M3-XBYi-2A55-fKeF-hhakWk
  LV Write Access        read/write
  LV Creation host, time vbox, 2025-01-13 10:02:13 +0100
  LV Status              available
  # open                 1
  LV Size                5.00 GiB
  Current LE             1280
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2

  --- Logical volume ---
  LV Path                /dev/rl_vbox/home
  LV Name                home
  VG Name                rl_vbox
  LV UUID                R9T4fW-Sdy9-Bmei-MwCO-Hf6R-RDUz-95MzHA
  LV Write Access        read/write
  LV Creation host, time vbox, 2025-01-13 10:02:13 +0100
  LV Status              available
  # open                 1
  LV Size                5.00 GiB
  Current LE             1280
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:3

  --- Logical volume ---
  LV Path                /dev/rl_vbox/root
  LV Name                root
  VG Name                rl_vbox
  LV UUID                p33AZH-HZbC-3yBu-oGZ0-vI3R-Sdt1-xMUmNU
  LV Write Access        read/write
  LV Creation host, time vbox, 2025-01-13 10:02:14 +0100
  LV Status              available
  # open                 1
  LV Size                10.00 GiB
  Current LE             2560
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
```

```shell
[root@vbox ~]# df -h
Filesystem                Size  Used Avail Use% Mounted on
devtmpfs                  4.0M     0  4.0M   0% /dev
tmpfs                     1.2G     0  1.2G   0% /dev/shm
tmpfs                     460M  6.3M  454M   2% /run
/dev/mapper/rl_vbox-root  9.8G  901M  8.4G  10% /
/dev/mapper/rl_vbox-home  4.9G   24K  4.6G   1% /home
/dev/mapper/rl_vbox-var   4.9G   72M  4.6G   2% /var
/dev/sda1                 2.0G  228M  1.8G  12% /boot
tmpfs                     230M     0  230M   0% /run/user/0
```

🌞 **Remplissez votre partition `/home`**

```shell
[root@vbox home]# dd if=/dev/zero of=/home/bjorn/bigfile bs=4M count=5000
```

🌞 **Constater que la partition est pleine**

```shell
[root@vbox home]# df -h
Filesystem                Size  Used Avail Use% Mounted on
devtmpfs                  4.0M     0  4.0M   0% /dev
tmpfs                     1.2G     0  1.2G   0% /dev/shm
tmpfs                     460M  6.3M  454M   2% /run
/dev/mapper/rl_vbox-root  9.8G  901M  8.4G  10% /
/dev/mapper/rl_vbox-home  4.9G  4.4G  256M  95% /home
```

🌞 **Agrandir la partition**

```shell
[root@vbox home]# sudo fdisk /dev/sda

Command (m for help): p

Disk /dev/sda: 40 GiB, 42949672960 bytes, 83886080 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x20539413

Device     Boot   Start      End  Sectors Size Id Type
/dev/sda1  *       2048  4196351  4194304   2G 83 Linux
/dev/sda2       4196352 48195583 43999232  21G 8e Linux LVM

Command (m for help): n
Partition type
   p   primary (2 primary, 0 extended, 2 free)
   e   extended (container for logical partitions)
Select (default p):

Using default response p.
Partition number (3,4, default 3):
First sector (48195584-83886079, default 48195584):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (48195584-83886079, default 83886079):

Created a new partition 3 of type 'Linux' and of size 17 GiB.

Command (m for help): w
The partition table has been altered.
Syncing disks.
```

```shell
[root@vbox home]# lvextend -L +10000 /dev/rl_vbox/home
  Size of logical volume rl_vbox/home changed from 5.00 GiB (1280 extents) to <14.77 GiB (3780 extents).
  Logical volume rl_vbox/home successfully resized.
[root@vbox home]# resize2fs /dev/rl_vbox/home
resize2fs 1.46.5 (30-Dec-2021)
Filesystem at /dev/rl_vbox/home is mounted on /home; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 2
The filesystem on /dev/rl_vbox/home is now 3870720 (4k) blocks long.
```

🌞 **Remplissez votre partition `/home`**

```shell
[root@vbox home]# dd if=/dev/zero of=/home/bjorn/bigfile bs=4M count=5000
dd: error writing '/home/bjorn/bigfile': No space left on device
3694+0 records in
3693+0 records out
15493746688 bytes (15 GB, 14 GiB) copied, 23.2277 s, 667 MB/s
```

🌞 **Utiliser ce nouveau disque pour étendre la partition `/home` de 40G**

```shell
[root@vbox ~]# pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
[root@vbox ~]# pvs
  PV         VG      Fmt  Attr PSize   PFree
  /dev/sda2  rl_vbox lvm2 a--  <20.98g     0
  /dev/sda3  rl_vbox lvm2 a--  <17.02g  7.25g
  /dev/sdb           lvm2 ---   40.00g 40.00g
```

```shell
[root@vbox ~]# vgextend rl_vbox /dev/sdb
  Volume group "rl_vbox" successfully extended
```

```shell
[root@vbox ~]# lvextend -L +40G /dev/rl_vbox/home
  Size of logical volume rl_vbox/home changed from <14.77 GiB (3780 extents) to <54.77 GiB (14020 extents).
  Logical volume rl_vbox/home successfully resized.
```

```shell
[root@vbox ~]# resize2fs /dev/rl_vbox/home
resize2fs 1.46.5 (30-Dec-2021)
Filesystem at /dev/rl_vbox/home is mounted on /home; on-line resizing required
old_desc_blocks = 2, new_desc_blocks = 7
The filesystem on /dev/rl_vbox/home is now 14356480 (4k) blocks long.
```

```shell
[root@vbox ~]# df -h
Filesystem                Size  Used Avail Use% Mounted on
devtmpfs                  4.0M     0  4.0M   0% /dev
tmpfs                     1.2G     0  1.2G   0% /dev/shm
tmpfs                     460M  6.4M  454M   2% /run
/dev/mapper/rl_vbox-root  9.8G  901M  8.4G  10% /
/dev/mapper/rl_vbox-home   54G   15G   38G  28% /home
```

# II. Gestion de users

🌞 **Gestion basique de users**

```shell
[root@vbox ~]# cat /etc/passwd
alice:x:1001:1007::/home/alice:/bin/bash
bob:x:1002:1010::/home/bob:/bin/bash
charlie:x:1003:1008::/home/charlie:/bin/bash
eve:x:1004:1009::/home/eve:/bin/bash
backup:x:1005:1011::/var/backup:/usr/bin/nologin
```

🌞 **La conf `sudo` doit être la suivante**

```conf
# Group admins : tous les droits
%admins ALL=(ALL)       ALL

# User Eve
eve ALL=(backup) /bin/ls
```

🌞 **Le dossier `/var/backup`**

```shell
[root@vbox ~]# chown backup:backup /var/backup
[root@vbox ~]# chmod 700 /var/backup
```

🌞 **Mots de passe des users, prouvez que**

```etc
[root@vbox ~]# nano /etc/shadow
alice:$6$pFPnGOY9qUYBT/./$4cMY6aJ6gygol1zFVbp19gKwo6akToX7Js3ZyOcf6wCx809W3gE7K0Q.5eJ.svesx50oUKiHzTOdy5JK3DPf1/:20101:0:99999:7:::
bob:$6$hcjKI5qP1NZuswXg$NbSzuneuMbsS2DNQCfGZB50AS28FkHZcmgpOoGlsscGU5jOOs7qK.y525DCVkoMEnfRHQG4QIGo7DzPn8QY6O0:20101:0:99999:7:::
charlie:$6$Bd9iOMrFZQHbKpOv$N8TojNkKLsGkudPZtF0g9SZ1Li0SwKs8y8VlO2.04MKEcrLOS097t6Vv6CQl/Z.VXGfC./GUI7u10APGmZAqO0:20101:0:99999:7:::
eve:$6$uXhp0YKp1zLVoMC9$Jz.sj3vKU1zD9AexfPM7ebaBCPULLTIj69fSInvB1hVAnfOAAIfAzxi5MxJ2AmoqGycSc1JqLc6ruCQ8.9eoa.:20101:0:99999:7:::
backup:$6$uO7l1FxCHlbpM4Oy$pntRwfVoJ.MGA.Jr0HDRYucp0D3UIIqDyqeEh3st4FfZ7BMEg8nEBg2J2EVeyVi9R/vK6PqXrW02jHvdYH36q/:20101:0:99999:7:::
```

🌞 **User eve**

```shell
[root@vbox ~]# su eve
[eve@vbox root]$ sudo -l
User eve may run the following commands on vbox:
    (backup) /bin/ls
[eve@vbox root]$
```

# III. Gestion du temps


🌞 **Je vous laisse gérer le bail vous-mêmes**

```shell
[root@vbox ~]# systemctl list-units -t service -a
 chronyd.service                                 loaded    active   running NTP client/server
```

```shell
[root@vbox ~]# date
Mon Jan 13 12:41:23 CET 2025
```

# IV. Gestion de service

Dans cette section vous allez écrire :

- un ptit script de sauvegarde basique `backup.sh`
- un fichier de service `backup.service`
  - pour que notre OS lance le script de backup comme un service
- un fichier de timer `backup.timer`
  - pour que notre OS lance à intervalles réguliers le service de backup


🌞 **Rendu attendu**

```shell
[root@vbox ~]# systemctl start backup
[root@vbox ~]# systemctl status backup
○ backup.service - Daily backup script
     Loaded: loaded (/etc/systemd/system/backup.service; static)
     Active: inactive (dead)

Jan 13 13:20:01 vbox systemd[1]: Started Daily backup script.
Jan 13 13:20:01 vbox backup.sh[52202]: sending incremental file list
Jan 13 13:20:01 vbox backup.sh[52202]: rsync: [sender] change_dir "/etc/ssh/ /var/log" failed: No such file or directory (2)
Jan 13 13:20:01 vbox backup.sh[52202]: sent 19 bytes  received 12 bytes  62.00 bytes/sec
Jan 13 13:20:01 vbox backup.sh[52202]: total size is 0  speedup is 0.00
Jan 13 13:20:01 vbox backup.sh[52202]: rsync error: some files/attrs were not transferred (see previous errors) (code 23) at main.c(1330) [sender=3.2.3]
Jan 13 13:20:01 vbox backup.sh[52209]: rm: missing operand
Jan 13 13:20:01 vbox backup.sh[52209]: Try 'rm --help' for more information.
Jan 13 13:20:01 vbox backup.sh[52200]: Sauvegarde effectuée avec succès dans /var/backup/backup_20250113_132001.tar.gz
Jan 13 13:20:01 vbox systemd[1]: backup.service: Deactivated successfully.
```

```shell
[root@vbox ~]# date
Mon Jan 13 13:22:05 CET 2025
[root@vbox ~]# systemctl list-timers --all
NEXT                        LEFT         LAST                        PASSED       UNIT                         ACTIVATES
Mon 2025-01-13 14:24:19 CET 1h 2min left Mon 2025-01-13 12:57:33 CET 24min ago    dnf-makecache.timer          dnf-makecache.service
Tue 2025-01-14 00:00:00 CET 10h left     Mon 2025-01-13 10:10:46 CET 3h 11min ago logrotate.timer              logrotate.service
Tue 2025-01-14 12:08:23 CET 22h left     Mon 2025-01-13 12:08:23 CET 1h 13min ago systemd-tmpfiles-clean.timer systemd-tmpfiles-clean.service
```