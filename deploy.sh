docker build -t rwuniard/multi-client:latest -t rwuniard/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t rwuniard/multi-server:latest -t rwuniard/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t rwuniard/multi-worker:latest -t rwuniard/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# We have login in .travis.yaml, so we can just push it to dockerhub
docker push rwuniard/multi-client:latest
docker push rwuniard/multi-server:latest
docker push rwuniard/multi-worker:latest
docker push rwuniard/multi-client:$SHA
docker push rwuniard/multi-server:$SHA
docker push rwuniard/multi-worker:$SHA

# the kubectl has been set in .travis.yaml 
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=rwuniard/multi-server:$SHA
kubectl set image deployments/client-deployment client=rwuniard/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=rwuniard/multi-worker:$SHA

