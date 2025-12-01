grafana:
  fullnameOverride: grafana
  adminUser: "${grafana_admin_user}"
  adminPassword: "${grafana_admin_password}"
  service:
    type: ClusterIP
  persistence:
    enabled: false

alertmanager:
  service:
    type: ClusterIP

prometheus:
  service:
    type: ClusterIP
  prometheusSpec:
    retention: 12h