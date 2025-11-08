#!/usr/bin/env bash
set -euo pipefail

REGION="eu-central-1"
CLUSTER="lesson-7-eks"
NS="django"
REL="django-app"
SVC="django-app"
REPO="lesson-7-ecr"
TAG="IMAGE_TAG"

echo "== EKS cluster status =="
aws eks describe-cluster --name "$CLUSTER" --region "$REGION" --query 'cluster.status' --output text

echo "== Kube nodes =="
kubectl get nodes

echo "== Helm release =="
helm status "$REL" -n "$NS" || (echo "Helm release not found" && exit 1)

echo "== Workloads =="
kubectl get deploy,po,svc,hpa -n "$NS"

echo "== Service check (port-forward) =="
kubectl port-forward -n "$NS" svc/$SVC 8080:80 >/dev/null 2>&1 &
PF_PID=$!
sleep 2
curl -sf http://127.0.0.1:8080/ >/dev/null && echo "Service OK" || (echo "Service failed" && kill $PF_PID && exit 1)
kill $PF_PID

echo "== ECR image present =="
aws ecr describe-images --repository-name "$REPO" --region "$REGION" --image-ids imageTag="$TAG" \
  --query 'imageDetails[0].imageDigest' --output text

echo "== ConfigMap present and referenced? =="
kubectl get configmap -n "$NS"
DEPLOY=$(kubectl get deploy -n "$NS" -o jsonpath='{.items[0].metadata.name}')
kubectl get deploy "$DEPLOY" -n "$NS" -o yaml | grep -E "configMapRef|configMap"

echo "All checks passed ✅"
