## cm 생성 및 설명

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: cmp-plugin
  namespace: argocd-system
data:
  avp-helm.yaml: |
    ---
    apiVersion: argoproj.io/v1alpha1
    kind: ConfigManagementPlugin
    metadata:
      name: argocd-vault-plugin-helm
    spec:
      allowConcurrency: true
      init:
        command:
          - bash
          - "-c"
          - |
            helm repo add bitnami https://charts.bitnami.com/bitnami
            helm repo add minio https://charts.min.io/
            helm repo add grafana https://grafana.github.io/helm-charts
            helm repo update
            helm dependency build
      discover:
        find:
          command:
            - sh
            - "-c"
            - "find . -name 'Chart.yaml' && find . -name 'values.yaml'"
      generate:
        command:
          - bash
          - "-c"
          - |
            helm template \$ARGOCD_APP_NAME -n \$ARGOCD_APP_NAMESPACE -f ./override-values.yaml . |
            argocd-vault-plugin generate -s argocd-system:avp-secret -
      lockRepo: false
  avp.yaml: |
    apiVersion: argoproj.io/v1alpha1
    kind: ConfigManagementPlugin
    metadata:
      name: argocd-vault-plugin
    spec:
      allowConcurrency: true
      discover:
        find:
          command:
            - sh
            - "-c"
            - "find . -type f -name '*.yaml' -exec grep -l '<path' {} \\\;"
      generate:
        command:
          - bash
          - "-c"
          - |
            cat \$(find . -type f -name '*.yaml' -exec grep -l '<path' {} \\;) |
            argocd-vault-plugin generate -s argocd-system:avp-secret -
      lockRepo: false
```


```
kind: Secret
apiVersion: v1
metadata:
  name: avp-secret
  namespace: argocd-system
type: Opaque
stringData:
  AVP_AUTH_TYPE: "token"
  AVP_TYPE: "vault"
  VAULT_ADDR: "https://vault.choigonyok.com"
  VAULT_TOKEN: "VAULT_ROOT_TOKEN"
```



UI접속후 
Settings > Repositories > CONNECT REPO

깃헙 토큰 생성

