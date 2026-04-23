## Projekt zaliczeniowy 2a (Google Cloud Platform + WordPress)

Tematem projektu jest zaprojektowanie i wdrożenie zautomatyzowanej infrastruktury chmurowej w środowisku Google Cloud Platform. W projekcie wykorzystano narzędzie Terraform do zarządzania zasobami chmurowymi oraz Ansible służącado automatyzacji procesu konfiguracji i instalacji oprogramowania.

Dodatkowo w projekcie zastosowano konteneryzację przy użyciu Dockera, obejmującą środowisko WordPress oraz bazę danych MySQL. W ramach wdrożonej aplikacji CMS WordPress utworzono blog o tematyce kolarskiej. 

### Instrukcja uruchomienia

1. Inicjacja terraform (przejdź do folderu /terraform): 
``` 
terraform init 
```
2. Wdrożenie terraform:
```
terraform apply
```
3. W pliku inventory.ini wpisz skopiowany adres IP (przejdź do folderu ```/ansible```).
4. Uruchomienie ansible:
```
ansible-playbook -i inventory.ini playbook.yml
```
5. Wejdź na adres IP w przeglądarce i przejdź przez proces instalacji WordPress.
6. Zainstaluj wtyczkę ```WPvivid```.
7. Przywróć backup strony (znajduje się w folderze ```/data```).

### Sprawdzenie bazy danych

1. Połączenie się z VM poprzez SSH:
```
ssh -i ~/.ssh/id_rsa bartek@<ADRES_IP_VM>
```
2. Wejście do konsoli bazy danych MySQL (hasło: root_password):
```
sudo docker exec -it wordpress_db mysql -u root -p
```
3. Wybór bazy danych wordpress:
```
USE wordpress;
```

### Przedmiot

PPwCh 2026

### Autorzy

Bartłomiej Handziak,
Konrad Iwanczewski
3 rok, grupa lab. 2
