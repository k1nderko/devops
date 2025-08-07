module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name_prefix = "ebs-csi-"
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

module "ebs_csi_driver" {
  source = "terraform-aws-modules/eks/aws//modules/aws-ebs-csi-driver"
  version = "~> 19.0"

  cluster_name = module.eks.cluster_name
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url

  ebs_csi_controller_role_name = module.ebs_csi_irsa_role.iam_role_name

  tags = {
    Environment = var.environment
  }
} 