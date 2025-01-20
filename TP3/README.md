# TP3 Admin : Vagrant

🌞 **Générer un `Vagrantfile`**

```shell
PS C:\Users\fayer\Desktop\Projets-exos\b2-linux> cd .\TP3\
PS C:\Users\fayer\Desktop\Projets-exos\b2-linux\TP3> vagrant init generic/ubuntu2204 --box-version 4.3.12
A `Vagrantfile` has been placed in this directory.
```

🌞 **Modifier le `Vagrantfile`**

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"
  config.vm.box_version = "4.3.12"
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: true
end
```

🌞 **Faire joujou avec une VM**

```bash
PS C:\Users\fayer\Desktop\Projets-exos\b2-linux\TP3> vagrant up
Bringing machine 'default' up with 'virtualbox' provider...

# une fois la VM allumée...
PS C:\Users\fayer\Desktop\Projets-exos\b2-linux\TP3> vagrant status
Current machine states:

default                   running (virtualbox)

PS C:\Users\fayer\Desktop\Projets-exos\b2-linux\TP3> vagrant ssh   
vagrant@ubuntu2204:~$ 


# on peut éteindre la VM avec
PS C:\Users\fayer\Desktop\Projets-exos\b2-linux\TP3> vagrant halt
==> default: Attempting graceful shutdown of VM...

# et la détruire avec
PS C:\Users\fayer\Desktop\Projets-exos\b2-linux\TP3> vagrant destroy -f
==> default: Destroying VM and associated drives..
```

## 2. Repackaging

🌞 **Repackager la box que vous avez choisie**

vagrant@ubuntu2204:~$ history
    1  sudo apt-get install vim
    3  sudo apt-get update
    6  sudo apt-get install netcat
    8  sudo apt-get install iproute2
    9  sudo apt-get install dnsutils

```bash
PS C:\Users\fayer\Desktop\Projets-exos\b2-linux\TP3> vagrant package --output super_box.box
==> default: Attempting graceful shutdown of VM...

# On ajoute le fichier .box à la liste des box que gère Vagrant
PS C:\Users\fayer\Desktop\Projets-exos\b2-linux\TP3> vagrant box add super_box super_box.box
==> box: Box file was not detected as metadata. Adding it directly...

# On devrait voir la nouvelle box dans la liste locale des boxes de Vagrant
PS C:\Users\fayer\Desktop\Projets-exos\b2-linux\TP3> vagrant box list
generic/ubuntu2204 (virtualbox, 4.3.12, (amd64))
super_box          (virtualbox, 0)
```

🌞 **Ecrivez un `Vagrantfile` qui lance une VM à partir de votre Box**

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "super_box"
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: true
end
```

```shell
PS C:\Users\fayer\Desktop\Projets-exos\b2-linux\TP3> vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'super_box'...
```

## 3. Moult VMs

[Vagrantfile 3A](./partie1/Vagrantfile-3A/Vagrantfile)

🌞 **Adaptez votre `Vagrantfile`** pour qu'il lance les VMs suivantes (en réutilisant votre box de la partie précédente)

[Vagrantfile 3B](./partie1/Vagrantfile-3B/Vagrantfile)

> *La syntaxe Ruby c'est vraiment dégueulasse.*
