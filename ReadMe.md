run the container locally 
docker run -d -p 80:80 <ECR_REPOSITORY_URI>:latest

docker run -d -p 80:80 medici_web_server:latest

docker image name
ECR repository name
docker build -t medici_web_server .