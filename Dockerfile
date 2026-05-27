FROM fedora:latest

RUN echo "proxy=http://10.0.0.2:3128" >> /etc/dnf/dnf.conf

RUN dnf install mariadb-server -y
RUN mysql_install_db
#NO ROOT PASSWORD

COPY ./SQL.txt /sql/SQL.txt

EXPOSE 3306

CMD ["/usr/sbin/mariadbd", "-u", "root"]