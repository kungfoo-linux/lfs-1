# Installing WordPress

To run WordPress we recommend your host supports:
 - PHP (>=5.6)
 - MySQL (>= 5.6)
 - nginx (>= 1.4)

### Step 1: Extract WordPress package

```sh
$ mkdir -pv /data/sites
$ cd /data/sites
$ tar -xf wordpress-4.4.2.tar.gz
```

### Step 2: Create the Database and a User

```sh
$ mysql -u root -p
mysql> create database wordpress;
mysql> grant all privileges on wordpress.* to "wordpress"@"%" identified by "your-password";
mysql> flush privileges;
mysql> exit
```

### Step 3: Set up wp-config.php

```sh
$ cd /data/sites/wordpress
$ cp wp-config-sample.php wp-config.php

Enter your database information under the section labeled.

DB_NAME
    The name of the database you created for WordPress in Step 2.
DB_USER
    The username you created for WordPress in Step 2.
DB_PASSWORD
    The password you chose for the WordPress username in Step 2.
DB_HOST
    The hostname you determined in Step 2 (usually localhost, but not always; see some possible DB_HOST values). If a port, socket, or pipe is necessary, append a colon (:) and then the relevant information to the hostname.
DB_CHARSET
    The database character set, normally should not be changed (see Editing wp-config.php).
DB_COLLATE
    The database collation should normally be left blank (see Editing wp-config.php).
```

### Step 4: Configure nginx

```sh
$ cat > /opt/nginx/conf/vhosts/blog.conf << "EOF"
server {
    listen            4000;
    server_name       localhost;

    access_log        logs/blog.access.log;

    location / {
        root          /data/sites/wordpress;
        index         index.php;
    }

    location ~ \.php$ {
        root          /data/sites/wordpress;
        fastcgi_pass  127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME      $fastcgi_script_name;
        include       fastcgi_params;
    }
}
EOF

$ nginx -s reload
```

### Step 5: Run the Install Script

```sh
# Access: http://localhost:4000

Site Title: fangxinmiao's blog
Username: fangxm
Password:
Your Email: smecf@163.com
Search Engine Visibility: [] Discourage search engines from indexing this site
```
