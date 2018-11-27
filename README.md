# gitbook-with-nginx
gitbook with nginx as web server


Add gitbook related files into gitbook folder then build and run it with docker.

docker build -it gitbook_nginx .
docker run -p 80:80 gitbook_nginx
