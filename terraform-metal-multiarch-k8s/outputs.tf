output "Kubernetes_Cluster_Info" {
  value = "\n\n Run: \n\n\t ssh root@${module.controllers.controller_addresses} kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes -w \n\n To troubleshoot (or monitor) spin-up, check the cloud-init output:\n\n\t ssh root@${module.controllers.controller_addresses} tail -f /var/log/cloud-init-output.log \n\n The initialization and spin-up process may take 5-7 minutes to complete."
}

output "kubernetes_api_address" {
  description = "The address of the Kubernetes API"
  value       = module.controllers.controller_addresses
}

output "kubernetes_kubeconfig" {
  description = "Kubeconfig for the newly created cluster"
  value       = module.controllers.kubeconfig
  sensitive   = true
}

output "kubernetes_kubeconfig_file" {
  description = "Kubecobnfig file for the newly created cluster"
  value       = module.controllers.kubeconfig_filename
}
