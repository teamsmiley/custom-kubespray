KUBESPRAY_VERSION=2.17.0
ENV=xgrid-c4

BASE_DIR=deploy
TARGET_DIR=${BASE_DIR}/kubespray-$KUBESPRAY_VERSION

set -e 
# set -x 

FILE=${TARGET_DIR}
if [ -d "$FILE" ]; 
then
  echo "$FILE is a exist"
else
  curl https://codeload.github.com/kubernetes-sigs/kubespray/zip/refs/tags/v$KUBESPRAY_VERSION -o ${TARGET_DIR}.zip --create-dirs
  unzip ${TARGET_DIR}.zip -d ${BASE_DIR}/
  rm -f ${TARGET_DIR}.zip
  rm -rf ${TARGET_DIR}/.gitmodules
fi

cp -r ${TARGET_DIR}/inventory/sample/ ${TARGET_DIR}/inventory/$ENV/

rm -f ${TARGET_DIR}/inventory/$ENV/inventory.ini

## 파일을 업데이트 변경하는 부분
# macos
sed -i'.original' 's/kube_version: .*/#kube_version:/' ${TARGET_DIR}/inventory/$ENV/group_vars/k8s_cluster/k8s-cluster.yml
sed -i'.original' 's/# kubeconfig_localhost: false/kubeconfig_localhost: true/' ${TARGET_DIR}/inventory/$ENV/group_vars/k8s_cluster/k8s-cluster.yml
sed -i'.original' 's/auto_renew_certificates: false/auto_renew_certificates: true/' ${TARGET_DIR}/inventory/$ENV/group_vars/k8s_cluster/k8s-cluster.yml
sed -i'.original' 's/container_manager: docker/container_manager: containerd/' ${TARGET_DIR}/inventory/$ENV/group_vars/k8s_cluster/k8s-cluster.yml

sed -i'.original' 's/etcd_deployment_type: docker/etcd_deployment_type: host/' ${TARGET_DIR}/inventory/$ENV/group_vars/etcd.yml
sed -i'.original' 's/inventory\/\*/''/' ${TARGET_DIR}/.gitignore

# linux
# sed -i 's/auto_renew_certificates: false/auto_renew_certificates: true/' ${TARGET_DIR}/inventory/$ENV/group_vars/k8s_cluster/k8s-cluster.yml

# cp -r config/$ENV/ansible.cfg ${TARGET_DIR}/
# cp -r config/$ENV/ssh-key     ${TARGET_DIR}/

cp -r config/$ENV/hosts.yml ${TARGET_DIR}/inventory/$ENV/

cat config/k8s-cluster.yml >> ${TARGET_DIR}/inventory/$ENV/group_vars/k8s_cluster/k8s-cluster.yml
cat config/cluster.yml >> ${TARGET_DIR}/cluster.yml

cat config/$ENV/group_vars/k8s_cluster/k8s-cluster.yml >> ${TARGET_DIR}/inventory/$ENV/group_vars/k8s_cluster/k8s-cluster.yml
cat config/$ENV/group_vars/all/all.yml >> ${TARGET_DIR}/inventory/$ENV/group_vars/all/all.yml

cp -r add-on/ ${TARGET_DIR}/



